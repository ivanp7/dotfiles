#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $CONF_DIR/plugged

mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/swap
mkdir -p $HOME/.vim/files/backup
mkdir -p $HOME/.vim/files/info
mkdir -p $HOME/.vim/files/swap
mkdir -p $HOME/.vim/files/undo
ln -sf $CONF_DIR/plugged $HOME/.vim/

