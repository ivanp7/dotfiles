#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

install -Dm 644 $CONF_DIR/*.wallpaper $HOME/wallpapers/

