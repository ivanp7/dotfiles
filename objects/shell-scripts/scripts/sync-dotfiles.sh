#!/bin/sh

HOST="$(hostname)"

sync()
{
    SYNC_COMMAND='"cd /home/shared/dotfiles; git pull"'
    REMOTE_HOST=$(echo "$1" | cut -d'/' -f2)
    if [ "$REMOTE_HOST" != "$HOST" ]
    then remote.sh $REMOTE_HOST wakeup_command "$SYNC_COMMAND"
    fi
}

cd $HOME/.password-store/computers
find . -mindepth 2 -maxdepth 2 -type d -name "net" |
    while read path; do sync $path; done

