# run tmux and construct environment
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
then
    # tmux attach \; run-shell ". $HOME/scripts/services/tmux-refresh-clients-functions.sh; refresh" || {
    tmux attach || {
        tmux new-session -d -x $(tput cols) -y $(tput lines) -s default-$(whoami) -n org "echo; neofetch; bash";
        tmux split-window -h -l 67 -t default-$(whoami) "sh $HOME/.when/update_calendar.sh";
        tmux split-window -v -t default-$(whoami) "sh $HOME/.todo/update_todo.sh";
        tmux select-pane -L
        shopt -q login_shell && tmux attach -t default-$(whoami) || exec tmux attach -t default-$(whoami);
    }
    # } && shopt -q login_shell || exit
fi

if [[ "$TERM" == "yaft-256color" ]]
then
    exit
fi
