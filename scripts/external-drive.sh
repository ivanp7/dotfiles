#!/bin/bash

DEFAULT_OPTIONS=rw,uid=$(whoami),gid=$(whoami),dmask=0022,fmask=0133,defaults

if [[ "$1" == "mount" ]]; then
    sudo mkdir -p /mnt/mount-$2
    OPTIONS=$(if [[ -z "$3" ]]; then echo "$DEFAULT_OPTIONS"; else echo "$3"; fi)
    sudo mount -o $OPTIONS /dev/$2 /mnt/mount-$2
elif [[ "$1" == "unmount" ]]; then
    sudo umount /mnt/mount-$2
    sudo rm -d /mnt/mount-$2
else
    echo Error: unknown command "$1"
    exit 1
fi

