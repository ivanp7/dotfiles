#!/bin/sh

WALLPAPER=$(find $HOME/wallpapers/ -name "*.pic" | shuf -n1)

if [ -n "$WALLPAPER" ]
then screen -c $HOME/.screenrc_noui yaft_wall $WALLPAPER;
else screen -c $HOME/.screenrc_noui yaft;
fi

clear

