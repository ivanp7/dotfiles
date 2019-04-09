#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/bin/
[ ! -L "$HOME/bin/df" ] && ln -sf $CONF_DIR/scripts $HOME/bin/df

