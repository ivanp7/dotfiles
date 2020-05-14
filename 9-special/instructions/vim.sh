#!/bin/sh

curl -fLo $HOME/.config/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p $HOME/.cache/vim/plugged
mkdir -p $HOME/.cache/vim/undo
mkdir -p $HOME/.cache/vim/swap
mkdir -p $HOME/.cache/vim/backup
mkdir -p $HOME/.cache/vim/view

