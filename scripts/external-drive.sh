#!/bin/bash

DEFAULT_OPTIONS=rw,uid=$(whoami),gid=$(whoami),dmask=0022,fmask=0133,defaults

case $1 in
    mount)
        sudo mkdir -p /mnt/mount-$2
        OPTIONS=$(if [[ -z "$3" ]]; then echo "$DEFAULT_OPTIONS"; else echo "$3"; fi)
        sudo mount -o $OPTIONS /dev/$2 /mnt/mount-$2
        ;;

    unmount)
        sudo umount /mnt/mount-$2
        sudo rm -d /mnt/mount-$2
        ;;

    *)
        echo Error: unknown command "$1"
        exit 1
esac

