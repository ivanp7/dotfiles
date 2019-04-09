#!/bin/sh

REMOTE_HOST="$1"

if [ ! -d "$HOME/.password-store/computers/$REMOTE_HOST" ]; then
    echo Error: unknown host "$REMOTE_HOST"
    exit 2
fi

LOCAL_SUBNET=$(pass /computers/$HOST/net/subnet 2> /dev/null)
REMOTE_SUBNET=$(pass /computers/$REMOTE_HOST/net/subnet 2> /dev/null)

if [ -z "$REMOTE_SUBNET" ] || [ "$LOCAL_SUBNET" != "$REMOTE_SUBNET" ]
then SCOPE=global
else SCOPE=local; fi

if [ "$REMOTE_HOST" != "$HOST" ]
then ADDRESS=$(pass /computers/$REMOTE_HOST/net/$SCOPE/ip-address 2> /dev/null)
else ADDRESS=127.0.0.1; fi
PORT=$(pass /computers/$REMOTE_HOST/net/$SCOPE/port-ssh 2> /dev/null)
WAKEUP_PORT=$(pass /computers/$REMOTE_HOST/net/$SCOPE/port-wakeup 2> /dev/null)
MAC_ADDRESS=$(pass /computers/$REMOTE_HOST/net/mac-address 2> /dev/null)

if [ -z "$PORT" ]; then PORT=22; fi
if [ -z "$WAKEUP_PORT" ]; then WAKEUP_PORT=40000; fi

MODE="$2"

case $MODE in
    status) COMMAND="nc -z $ADDRESS $PORT" ;;
    wakeup) 
        if [ -n $MAC_ADDRESS ]
        then COMMAND="wol -p $WAKEUP_PORT -i $ADDRESS $MAC_ADDRESS"
        else
            echo Error: MAC address of the remote host is unknown.
            exit 1
        fi 
        ;;

    upload) COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' $3 '$USER@$ADDRESS:$4'" ;;
    download) COMMAND="rsync -vP ${@:5} -e 'ssh -p $PORT' '$USER@$ADDRESS:$3' $4" ;;

    mount) COMMAND="sshfs $USER@$ADDRESS:$3 $4 -p $PORT -o reconnect ${@:5}" ;;
    unmount) COMMAND="fusermount3 -u $3" ;;

    command)
        SSH_FLAGS="-p $PORT"
        COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USER@$ADDRESS ${@:3}"
        ;;

    tunnel)
        LOCAL_PORT=$3
        if [ -z $LOCAL_PORT ]; then LOCAL_PORT=65535; fi

        SSH_FLAGS="-D $LOCAL_PORT -N -p $PORT"
        COMMAND="TERM=xterm-256color ssh $SSH_FLAGS $USER@$ADDRESS"
        ;;

    *)
        echo Error: unknown command "$MODE"
        exit 1
esac

echo $COMMAND
bash -c "$COMMAND"

