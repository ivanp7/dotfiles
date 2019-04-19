#!/bin/sh

if [ ! -d "$HOME/.password-store/computers" ]
then echo "Error: no remote hosts information available."; exit 2; fi

MODE="$1"
REST_P="${@:2}"

HOST="$(hostname)"

case $MODE in
    wakeup) COMMAND="wakeup" ;;
    upload) COMMAND="upload" ;;   wakeup-upload) COMMAND="wakeup-upload" ;;
    command) COMMAND="command" ;; wakeup-command) COMMAND="wakeup-command" ;;

    *) echo "Error: unsupported command '$MODE'"; exit 1
esac

operation()
{
    REMOTE_HOST="$1"
    if [ "$REMOTE_HOST" != "$HOST" ]
    then 
        echo "Host '$REMOTE_HOST':"
        remote.sh "$REMOTE_HOST" "$COMMAND" $REST_P
    fi
}

for remote_path in $(cd $HOME/.password-store/computers; find . -mindepth 2 -maxdepth 2 -type d -name "net")
do operation $(echo "$remote_path" | cut -d'/' -f2)
done

