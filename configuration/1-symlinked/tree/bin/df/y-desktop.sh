#!/bin/sh

mkdir -p /tmp/tmux-refresh-service-$(whoami)

TTY=$(tty | sed 's@/dev/@@; s@/@@')
echo -n $TTY > /tmp/tmux-refresh-service-$(whoami)/tmp

if [ -f "$HOME/wallpapers/yaft.wallpaper" ]
then screen -c $HOME/.screenrc_noui yaft_wall $HOME/wallpapers/yaft.wallpaper;
else screen -c $HOME/.screenrc_noui yaft;
fi

rm /tmp/tmux-refresh-service-$(whoami)/$TTY

clear

