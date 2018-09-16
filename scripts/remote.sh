#!/bin/bash

HOST="$1"

DESCRIPTION="$(grep "^$HOST " ~/.known_ssh_hosts)"
read -r COMPUTER USERNAME HOSTNAME PORT WAKEUP_PORT MAC_ADDRESS <<< "$DESCRIPTION"

if [[ -z "$COMPUTER" ]]; then
    echo Error: unknown host "$HOST"
    exit 2
fi

MODE="$2"

if [[ "$MODE" == "status" ]]; then
    COMMAND="nc -z $HOSTNAME $PORT"
elif [[ "$MODE" == "wakeup" ]]; then
    COMMAND="wol -p $WAKEUP_PORT -i $HOSTNAME $MAC_ADDRESS"

elif [[ "$MODE" == "upload" ]]; then
    COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' $3 '$USERNAME@$HOSTNAME:$4'"
elif [[ "$MODE" == "download" ]]; then
    COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' '$USERNAME@$HOSTNAME:$3' $4"

elif [[ "$MODE" == "mount" ]]; then
    COMMAND="sshfs $USERNAME@$HOSTNAME:$3 $4 -p $PORT -o reconnect"
elif [[ "$MODE" == "unmount" ]]; then
    COMMAND="fusermount3 -u $3"

elif [[ "$MODE" == "command" ]]; then
    SSH_FLAGS="-p $PORT"
    COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME ${@:3}"
elif [[ "$MODE" == "tunnel" ]]; then
    LOCAL_PORT=$3
    if [[ -z "$LOCAL_PORT" ]]; then LOCAL_PORT=65535; fi

    SSH_FLAGS="-D $LOCAL_PORT -N -p $PORT"
    COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME"

else
    echo Error: unknown command "$MODE"
    exit 1
fi

echo $COMMAND
bash -c "$COMMAND"

