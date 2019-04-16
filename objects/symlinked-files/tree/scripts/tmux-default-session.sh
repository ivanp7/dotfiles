# ORG_COLS=68
ORG_COLS=100

tmux new-session -d -x $(tput cols) -y $(tput lines) -s default-$(whoami) -n org "sh $HOME/.when/update_calendar.sh";
tmux split-window -v -t default-$(whoami) "sh $HOME/.task/update_task.sh";
tmux split-window -h -b -f -l $(( $(tput cols) - $ORG_COLS )) -t default-$(whoami) "$HOME/bin/df/print-motd.sh; $SHELL";
[[ -o login ]] && tmux attach -t default-$(whoami) || exec tmux attach -t default-$(whoami);

