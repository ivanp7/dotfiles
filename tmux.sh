#!/bin/bash

# run tmux in nonlogin shell and construct environment
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
then
    tmux attach || { \
        tmux new-session -d -s default -n terminal "echo; neofetch; bash";
        tmux split-window -v -t default;
        exec tmux attach -t default;
    } && shopt -q login_shell || exit
fi

