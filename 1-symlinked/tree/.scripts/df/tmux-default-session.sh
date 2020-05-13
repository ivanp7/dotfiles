TMUX_DEFAULT_SESSION_NAME=default

WIDTH=$(tput cols)
HEIGHT=$(tput lines)

# ORG_COLS=68
ORG_COLS=80

tmux new-session -d -x $WIDTH -y $HEIGHT -s $TMUX_DEFAULT_SESSION_NAME -n monitor "glances"
tmux new-window -n org "display-calendar.sh"
tmux split-window -v -t $TMUX_DEFAULT_SESSION_NAME "display-tasks.sh"
tmux split-window -h -b -f -l $(($WIDTH - $ORG_COLS)) -t $TMUX_DEFAULT_SESSION_NAME "$HOME/.scripts/df/tmux-motd.sh; $SHELL"
task > /dev/null 2>&1
[[ -o login ]] && tmux attach -t $TMUX_DEFAULT_SESSION_NAME || exec tmux attach -t $TMUX_DEFAULT_SESSION_NAME

