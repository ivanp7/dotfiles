#!/bin/bash

if [ -f $HOME/wallpapers/yaft.wallpaper ]
then screen -c $HOME/.screenrc_nointerface yaft_wall $HOME/wallpapers/yaft.wallpaper;
else screen -c $HOME/.screenrc_nointerface yaft;
fi

clear

