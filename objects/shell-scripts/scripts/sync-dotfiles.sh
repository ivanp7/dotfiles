#!/bin/sh

SYNC_COMMAND='"cd /home/shared/dotfiles; git pull"'
HOST="$(hostname)"

sync()
{
    REMOTE_HOST=$1
    if [ "$REMOTE_HOST" != "$HOST" ]
    then 
        echo "Synchronizing '$REMOTE_HOST'..."
        remote.sh $REMOTE_HOST wakeup_command "$SYNC_COMMAND"
    fi
}

cd $HOME/.password-store/computers
for remote_path in $(find . -mindepth 2 -maxdepth 2 -type d -name "net")
do sync $(echo "$remote_path" | cut -d'/' -f2)
done

