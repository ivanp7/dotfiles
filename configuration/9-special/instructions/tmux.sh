#!/bin/sh

DIR=$(realpath $(dirname $0)/../../1-symlinked/tree/.tmux/plugins/tpm)

case $1 in
    i)
        if [ ! -d $DIR ]
        then git clone https://github.com/tmux-plugins/tpm $DIR; fi
        ;;

    u)
        ;;

    *)
        exit 1
esac

