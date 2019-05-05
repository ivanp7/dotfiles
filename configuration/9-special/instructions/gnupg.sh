#!/bin/sh

case $1 in
    i)
        chmod 700 $HOME/.gnupg/
        chmod 600 $HOME/.gnupg/gpg.conf $HOME/.gnupg/gpg-agent.conf 
        ;;

    u)
        ;;

    *)
        exit 1
esac

