#!/bin/bash

run () { echo "$1"; sh -c "$1"; }

error ()
{
    echo "Error: $1"
    if [ -n "$2" ]; then exit $2
    else exit 1; fi
}

# ------------------------------------------------------------------------------

REMOTE_HOST="$1"
MODE="$2"
FIRST_P="$3"
SECOND_P="$4"
REST_P="${@:5}"

# ------------------------------------------------------------------------------

unmount () { run "fusermount3 -u $FIRST_P"; }

# ------------------------------------------------------------------------------

case $MODE in
    unmount) unmount; exit
esac

# ------------------------------------------------------------------------------

if [ ! -d "$HOME/.password-store/computers/$REMOTE_HOST/net" ]
then error "unknown host '$REMOTE_HOST'" 2; fi

get () { pass computers/$1/net/$2 2> /dev/null; }

HOST="$(hostname)"

LOCAL_IP="$(curl https://ipinfo.io/ip 2> /dev/null)"
REMOTE_IP="$(get $REMOTE_HOST global/ip-address)"

if [ "$LOCAL_IP" != "$REMOTE_IP" ]
then SCOPE="global"
else SCOPE="local"; fi

if [ "$REMOTE_HOST" != "$HOST" ]
then ADDRESS="$(get $REMOTE_HOST $SCOPE/ip-address)"
else ADDRESS="127.0.0.1"; fi

PORT="$(get $REMOTE_HOST $SCOPE/port-ssh)"
WAKEUP_PORT="$(get $REMOTE_HOST $SCOPE/port-wakeup)"
WAKEUP_DELAY="$(get $REMOTE_HOST wakeup-delay)"
MAC_ADDRESS="$(get $REMOTE_HOST mac-address)"

if [ -z "$PORT" ]; then PORT="22"; fi
if [ -z "$WAKEUP_PORT" ]; then WAKEUP_PORT="40000"; fi
if [ -z "$WAKEUP_DELAY" ]; then WAKEUP_DELAY="1"; fi

# ------------------------------------------------------------------------------

get_url () { echo "ssh://$USER@$ADDRESS:$PORT"; }

STATUS_TIMEOUT=5
status_of () { run "nc -w $STATUS_TIMEOUT -z $ADDRESS $PORT"; }

wakeup ()
{
    if [ -n "$MAC_ADDRESS" ]
    then run "wol -p $WAKEUP_PORT $([ "$SCOPE" = "global" ] && echo "-i $ADDRESS") $MAC_ADDRESS"
    else error "MAC address of the remote host is unknown."
    fi 
}

wakeup_run () 
{
    if ! status_of
    then 
        wakeup
        echo "Waiting $WAKEUP_DELAY seconds for host to wake up..."
        sleep $WAKEUP_DELAY
    fi
    $1
}

upload () { run "rsync -vP $REST_P -e 'ssh -p $PORT' $FIRST_P '$USER@$ADDRESS:$SECOND_P'"; }
download () { run "rsync -vP $REST_P -e 'ssh -p $PORT' '$USER@$ADDRESS:$FIRST_P' $SECOND_P"; }

mount () { run "sshfs $USER@$ADDRESS:$FIRST_P $SECOND_P -p $PORT -o reconnect $REST_P"; }

command_to () { run "TERM=xterm-256color ssh -p $PORT $USER@$ADDRESS $FIRST_P $SECOND_P $REST_P"; }

tunnel ()
{
    if [ -n "$FIRST_P" ]
    then LOCAL_PORT="$FIRST_P"
    else LOCAL_PORT="65535"
    fi
    run "ssh -D $LOCAL_PORT -N -p $PORT $USER@$ADDRESS"
}

# ------------------------------------------------------------------------------

case $MODE in
    get_url) get_url ;;

    status) status_of ;;
    wakeup) wakeup ;;

    upload) upload ;;      wakeup-upload) wakeup_run upload ;;
    download) download ;;  wakeup-download) wakeup_run download ;;

    mount) mount ;;        wakeup-mount) wakeup_run mount ;;

    command) command_to ;; wakeup-command) wakeup_run command_to ;;

    tunnel) tunnel ;;      wakeup-tunnel) wakeup_run tunnel ;;

    *) error "unknown command '$MODE'"
esac

