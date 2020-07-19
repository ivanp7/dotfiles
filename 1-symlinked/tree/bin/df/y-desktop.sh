#!/bin/sh

WALLPAPER=$HOME/wallpapers/yaft

if [ -e "$WALLPAPER" ] && file -b -i "$WALLPAPER" | grep -q "^image/"
then screen -c $XDG_CONFIG_HOME/screen/screenrc_noui yaft_wall "$WALLPAPER";
else screen -c $XDG_CONFIG_HOME/screen/screenrc_noui yaft;
fi

clear

