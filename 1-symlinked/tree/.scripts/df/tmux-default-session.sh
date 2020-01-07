TMUX_DEFAULT_SESSION_NAME=default

# ORG_COLS=68
ORG_COLS=100

tmux new-session -d -x $(tput cols) -y $(tput lines) -s $TMUX_DEFAULT_SESSION_NAME -n monitor "glances"
tmux new-window -n org "sh $HOME/.scripts/df/update_calendar.sh"
tmux split-window -v -t $TMUX_DEFAULT_SESSION_NAME "sh $HOME/.scripts/df/update_task.sh"
tmux split-window -h -b -f -l $(( $(tput cols) - $ORG_COLS )) -t $TMUX_DEFAULT_SESSION_NAME "$HOME/.scripts/df/tmux-motd.sh; $SHELL"
task > /dev/null 2>&1
[[ -o login ]] && tmux attach -t $TMUX_DEFAULT_SESSION_NAME || exec tmux attach -t $TMUX_DEFAULT_SESSION_NAME

