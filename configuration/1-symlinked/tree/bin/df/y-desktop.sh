#!/bin/sh

WALLPAPER=$(find -L $HOME/wallpapers/ -name "*.pic" | shuf -n1)

if [ -n "$WALLPAPER" ]
then screen -c $HOME/.screenrc_noui yaft_wall $WALLPAPER;
else screen -c $HOME/.screenrc_noui yaft;
fi

clear

