#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/wallpapers
install -Dm 644 $CONF_DIR/*.wallpaper $HOME/wallpapers/

