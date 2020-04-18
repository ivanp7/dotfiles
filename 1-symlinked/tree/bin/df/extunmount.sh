#!/bin/sh

cd /dev

EXCLUSIONS="\(/\|/boot\|/home\)$"

DEVICE="$1"

if [ -z "$DEVICE" ]
then 
    lsblk -lp | grep "part /" | grep -v "$EXCLUSIONS" | 
        awk '{print $1 " (" $4 ") @ " $7}'
    exit 0
fi

sudo umount "$DEVICE"

