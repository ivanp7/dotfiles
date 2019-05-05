#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))

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
    service=$1
    timer=$(echo $service | sed "s/service$/timer/")

    if [ -f "$timer" ]
    then target=$timer
    else target=$service
    fi

    ln -sf $service $TARGET_DIR/
    [ -e "$timer" ] && ln -sf $timer $TARGET_DIR/

    systemctl $USER_FLAG enable --now $(basename $target)
}

uninstall()
{
    service=$1
    timer=$(echo $service | sed "s/service$/timer/")

    if [ -f "$timer" ]
    then target=$timer
    else target=$service
    fi

    systemctl $USER_FLAG disable --now $(basename $target)

    [ -e "$TARGET_DIR/$(basename $service)" ] && rm "$TARGET_DIR/$(basename $service)"
    [ -e "$TARGET_DIR/$(basename $timer)" ] && rm "$TARGET_DIR/$(basename $timer)"
}

case $1 in
    i) OP=install ;;
    u) OP=uninstall ;;
    *) exit 1 ;;
esac

for service in $(find $CONF_DIR/units -type f -name "*.service" | sed 's,^\./,,')
do $OP $service; done

systemctl $USER_FLAG daemon-reload

