#!/bin/bash

HOST="$1"

DESCRIPTION="$(grep "^$HOST " $HOME/.ssh_known_hosts)"
read -r COMPUTER USERNAME HOSTNAME PORT WAKEUP_PORT MAC_ADDRESS <<< "$DESCRIPTION"

if [[ -z "$COMPUTER" ]]; then
    echo Error: unknown host "$HOST"
    exit 2
fi

MODE="$2"

case $MODE in
    status) COMMAND="nc -z $HOSTNAME $PORT" ;;
    wakeup) COMMAND="wol -p $WAKEUP_PORT -i $HOSTNAME $MAC_ADDRESS" ;;

    upload) COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' $3 '$USERNAME@$HOSTNAME:$4'" ;;
    download) COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' '$USERNAME@$HOSTNAME:$3' $4" ;;

    mount) COMMAND="sshfs $USERNAME@$HOSTNAME:$3 $4 -p $PORT -o reconnect ${@:5}" ;;
    unmount) COMMAND="fusermount3 -u $3" ;;

    command)
        SSH_FLAGS="-p $PORT"
        COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME ${@:3}"
        ;;

    tunnel)
        LOCAL_PORT=$3
        if [[ -z "$LOCAL_PORT" ]]; then LOCAL_PORT=65535; fi

        SSH_FLAGS="-D $LOCAL_PORT -N -p $PORT"
        COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USERNAME@$HOSTNAME"
        ;;

    *)
        echo Error: unknown command "$MODE"
        exit 1
esac

echo $COMMAND
bash -c "$COMMAND"

