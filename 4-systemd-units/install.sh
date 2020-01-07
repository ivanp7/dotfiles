#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))
UNINST_SCRIPT=$1

if [ "$(id -u)" -ne 0 ]
then
    mkdir -p $HOME/.config/systemd/user
    TARGET_DIR=$HOME/.config/systemd/user
    USER_FLAG=--user
else
    TARGET_DIR=/etc/systemd/system
    USER_FLAG=
fi

install()
{
    local service=$1
    local timer=$(echo $service | sed "s/service$/timer/")

    if [ -f "$timer" ]
    then local target=$timer
    else local target=$service
    fi

    ln -sf $service $TARGET_DIR/
    [ -e "$timer" ] && ln -sf $timer $TARGET_DIR/

    systemctl $USER_FLAG enable --now $(basename $target)

    if [ -n "$UNINST_SCRIPT" ]
    then
        if [ -f "$timer" ]
        then echo 'uninstall_service "'"$(basename $service)"'" "'$(basename $timer)'"' >> $UNINST_SCRIPT
        else echo 'uninstall_service "'"$(basename $service)"'"' >> $UNINST_SCRIPT
        fi
    fi
}

[ -n "$UNINST_SCRIPT" ] &&
echo '
TARGET_DIR='"$TARGET_DIR"'
USER_FLAG='"$USER_FLAG"'
uninstall_service ()
{
    local service=$1
    local timer=$2

    if [ -n "$timer" ]
    then local target=$timer
    else local target=$service
    fi

    systemctl $USER_FLAG disable --now $target

    [ -e "$TARGET_DIR/$service" ] && rm "$TARGET_DIR/$service"
    [ -e "$TARGET_DIR/$timer" ] && rm "$TARGET_DIR/$timer"
}
' >> $UNINST_SCRIPT

for service in $(find $CONF_DIR/units -type f -name "*.service" | sed 's,^\./,,')
do install $service; done

systemctl $USER_FLAG daemon-reload

