#!/bin/sh

[ -x "$XDG_CONFIG_HOME/tmux/motd.sh" ] && $XDG_CONFIG_HOME/tmux/motd.sh
printf "\n\n\n\n"
neofetch
echo
fortune.sh

