#!/bin/bash

mkdir -p $HOME/.tmux_tmp

TTY=$(tty | sed 's@/dev/@@; s@/@@')
echo -n $TTY > $HOME/.tmux_tmp/tmp

if [ -f $HOME/wallpapers/yaft.wallpaper ]
then screen -c $HOME/.screenrc_nointerface yaft_wall $HOME/wallpapers/yaft.wallpaper;
else screen -c $HOME/.screenrc_nointerface yaft;
fi

rm $HOME/.tmux_tmp/$TTY

clear

