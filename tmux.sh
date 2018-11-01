# run tmux and construct environment
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
then
    tmux attach || {
        tmux new-session -d -x $(tput cols) -y $(tput lines) -s default -n org "echo; neofetch; bash";
        tmux split-window -h -l 67 -t default "sh $HOME/.when/update_calendar.sh";
        tmux split-window -v -t default "sh $HOME/.todo/update_todo.sh";
        tmux select-pane -L
        shopt -q login_shell && tmux attach -t default || exec tmux attach -t default;
    } && shopt -q login_shell || exit
fi

