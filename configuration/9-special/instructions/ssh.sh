#!/bin/sh

case $1 in
    i)
        chmod 700 $HOME/.ssh/
        chmod 600 $HOME/.ssh/config
        ;;

    u)
        ;;

    *)
        exit 1
esac

