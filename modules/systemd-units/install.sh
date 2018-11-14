#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

if [ $EUID -ne 0 ]
then
    mkdir -p $HOME/.config/systemd/user/
    TARGET_DIR=$HOME/.config/systemd/user/
    USER_FLAG=--user
else
    TARGET_DIR=/etc/systemd/system/
fi

for service in $(find $CONF_DIR/units/ -type f -name "*.service")
do
    timer=$(echo $service | sed "s/service$/timer/")

    if [ -f $timer ]
    then
        target=$timer
    else
        target=$service
    fi

    systemctl $USER_FLAG stop $(basename $target)
    systemctl $USER_FLAG disable $(basename $target)

    ln -sf $service $TARGET_DIR
    [ -f $timer ] && ln -sf $timer $TARGET_DIR

    systemctl $USER_FLAG enable $(basename $target)
done

systemctl $USER_FLAG daemon-reload

