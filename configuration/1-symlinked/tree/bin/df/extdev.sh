#!/bin/sh

MODE="$1"
shift 1

case $MODE in
    list)
        echo "Mounted devices:"
        ls /mnt/dev/ 2> /dev/null
        ;;

    mount)
        DEVICE="$1"
        if [ -z "$DEVICE" ]; then echo "Error: no device supplied."; exit 1; fi
        shift 1
        OPTIONS="$@"
        if [ -z "$OPTIONS" ]
        then OPTIONS="rw,uid=$(whoami),gid=$(whoami),dmask=0022,fmask=0133,defaults"
        fi

        if mountpoint -q /mnt/dev/$DEVICE
        then
            echo "Error: device '$DEVICE' is already mounted"
            exit 1
        fi

        sudo mkdir -p /mnt/dev/$DEVICE
        if ! sudo mount -o $OPTIONS /dev/$DEVICE /mnt/dev/$DEVICE
        then
            sudo rm -d /mnt/dev/$DEVICE 
            echo "Error mounting device '$DEVICE'"
            exit 1
        fi
        ;;

    unmount)
        DEVICE="$1"
        if [ -z "$DEVICE" ]; then echo "Error: no device supplied."; exit 1; fi

        if ! mountpoint -q /mnt/dev/$DEVICE
        then
            echo "Error: device '$DEVICE' is not mounted"
            exit 1
        fi

        sudo umount /mnt/dev/$DEVICE
        sudo rm -d /mnt/dev/$DEVICE
        ;;

    *)
        echo "Error: unknown command '$MODE'"
        exit 1
esac

