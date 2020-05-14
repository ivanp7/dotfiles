#!/bin/sh

[ -x "$XDG_CONFIG_HOME/tmux/motd.sh" ] && $XDG_CONFIG_HOME/tmux/motd.sh
echo
echo
echo
neofetch
echo

