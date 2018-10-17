#!/bin/bash

cd `dirname $0`
CONF_DIR=$PWD

mkdir -p $HOME/.vim
mkdir -p $HOME/.vim/swap
mkdir -p $HOME/.vim/files/backup
mkdir -p $HOME/.vim/files/info
mkdir -p $HOME/.vim/files/swap
mkdir -p $HOME/.vim/files/undo

ln -sf $CONF_DIR/vimrc $HOME/.vim/
ln -sf $CONF_DIR/autoload $HOME/.vim/
ln -sf $CONF_DIR/plugged $HOME/.vim/
ln -sf $CONF_DIR/filetype.vim $HOME/.vim/
ln -sf $CONF_DIR/vlime-server.sh $HOME/.vim/

