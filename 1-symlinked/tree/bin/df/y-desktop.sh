#!/bin/sh

WALLPAPER="$(find -L $HOME/wallpapers/ -type f -o -type l | 
    while read file
    do
        if xdg-mime query filetype "$file" | grep -q "^image/"
        then echo "$file"
        fi
    done | shuf -n1)"

if [ -n "$WALLPAPER" ]
then screen -c $HOME/.screenrc_noui yaft_wall $WALLPAPER;
else screen -c $HOME/.screenrc_noui yaft;
fi

clear

