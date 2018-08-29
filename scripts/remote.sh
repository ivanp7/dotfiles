#!/bin/bash

DESCRIPTION="$(grep "^$2 " ~/.known_ssh_hosts)"
read -r COMPUTER USERNAME HOSTNAME PORT WAKEUP_PORT MAC_ADDRESS <<< "$DESCRIPTION"

if [[ -z "$COMPUTER" ]]; then
    echo Error: unknown host "$2"
    exit 2
fi

if [[ "$1" == "status" ]]; then
    COMMAND="nc -z $HOSTNAME $PORT"
elif [[ "$1" == "wakeup" ]]; then
    COMMAND="wol -p $WAKEUP_PORT -i $HOSTNAME $MAC_ADDRESS"

elif [[ "$1" == "upload" ]]; then
    COMMAND="rsync -avP ${@:5} -e 'ssh -p $PORT' $3 '$USERNAME@$HOSTNAME:$4'"
elif [[ "$1" == "download" ]]; then
    COMMAND="rsync -avP ${@:5} -e 'ssh -p $PORT' '$USERNAME@$HOSTNAME:$3' $4"

elif [[ "$1" == "mount" ]]; then
    COMMAND="sshfs $USERNAME@$HOSTNAME:$3 $4 -p $PORT -o reconnect"
elif [[ "$1" == "unmount" ]]; then
    COMMAND="fusermount3 -u $3"

elif [[ "$1" == "command" ]]; then
    SSH_FLAGS="-p $PORT"
    COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME ${@:3}"
elif [[ "$1" == "tunnel" ]]; then
    LOCAL_PORT=$3
    if [[ -z "$LOCAL_PORT" ]]; then LOCAL_PORT=65535; fi

    SSH_FLAGS="-D $LOCAL_PORT -N -p $PORT"
    COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME"

else
    echo Error: unknown command "$1"
    exit 1
fi

echo $COMMAND
bash -c "$COMMAND"

