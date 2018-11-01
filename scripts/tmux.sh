#!/bin/bash

# run tmux in nonlogin shell and construct environment
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
then
    tmux attach || exec tmux new-session -s default -n terminal "echo; neofetch; bash" && shopt -q login_shell || exit
fi

