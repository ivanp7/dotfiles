#!/bin/sh

if [ -f "$HOME/wallpapers/yaft.wallpaper" ]
then screen -c $HOME/.screenrc_noui yaft_wall $HOME/wallpapers/yaft.wallpaper;
else screen -c $HOME/.screenrc_noui yaft;
fi

clear

