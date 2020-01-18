#!/bin/sh

WALLPAPER="$(find -L $HOME/wallpapers/ -type f -o -type l | 
    while read file
    do file -b -i "$file" | grep -q "^image/" && echo "$file"
    done | shuf -n 1)"

if [ -n "$WALLPAPER" ]
then screen -c $HOME/.screenrc_noui yaft_wall $WALLPAPER;
else screen -c $HOME/.screenrc_noui yaft;
fi

clear

