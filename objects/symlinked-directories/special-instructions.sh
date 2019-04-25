#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

if [ ! -d $CONF_DIR/tree/.tmux/plugins/tpm ]
then git clone https://github.com/tmux-plugins/tpm $CONF_DIR/tree/.tmux/plugins/tpm; fi

mkdir -p $HOME/.vim/swap
mkdir -p $HOME/.vim/files/backup
mkdir -p $HOME/.vim/files/info
mkdir -p $HOME/.vim/files/swap
mkdir -p $HOME/.vim/files/undo

