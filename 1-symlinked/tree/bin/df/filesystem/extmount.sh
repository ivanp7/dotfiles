#!/bin/sh

cd /dev

DEVICE="$1"

if [ -z "$DEVICE" ]
then lsblk -lp | grep "part $" | awk '{print $1 " (" $4 ")"}'; exit 0
fi

sudo mount "$DEVICE" 2> /dev/null && exit 0

MOUNTPOINT="$2"

if [ -z "$MOUNTPOINT" ]
then MOUNTPOINT="/mnt/dev/$(basename $DEVICE)"
fi

if mountpoint -q "$MOUNTPOINT"
then echo "Error: directory '$MOUNTPOINT' is a mountpoint already."; exit 1
fi

sudo mkdir -p -- "$MOUNTPOINT"

MOUNT_OPTIONS="$3"
MOUNT_OPTIONS_EXTRA="$4"

if [ -z "$MOUNT_OPTIONS" ]
then MOUNT_OPTIONS="defaults,rw,uid=$(id -u),gid=$(id -g),dmask=0022,fmask=0133"
fi

if [ -n "$MOUNT_OPTIONS_EXTRA" ]
then MOUNT_OPTIONS+=",$MOUNT_OPTIONS_EXTRA"
fi

sudo mount -o "$MOUNT_OPTIONS" "$DEVICE" "$MOUNTPOINT"

