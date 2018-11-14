#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

if [ ! -d $CONF_DIR/plugins/tpm ]
then git clone https://github.com/tmux-plugins/tpm $CONF_DIR/plugins/tpm
fi

mkdir -p $HOME/.tmux/
ln -sf $CONF_DIR/plugins $HOME/.tmux/

