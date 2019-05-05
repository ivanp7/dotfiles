#!/bin/sh

case $1 in
    i)
        mkdir -p $HOME/.vim/swap
        mkdir -p $HOME/.vim/files/backup
        mkdir -p $HOME/.vim/files/info
        mkdir -p $HOME/.vim/files/swap
        mkdir -p $HOME/.vim/files/undo
        ;;

    u)
        ;;

    *)
        exit 1
esac

