#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

case $1 in
    "")
        echo "Installing everything:"
        for object in $(find $CONF_DIR/objects/ -mindepth 2 -maxdepth 2 -type f -name install.sh)
        do
            echo "Installing object '$(basename $(dirname $object))'..."
            $object
            # echo $object
        done
        echo "Done!"
        ;;

    *)
        if [ ! -x "$CONF_DIR/objects/$1/install.sh" ]
        then echo "Error: invalid object '$1'."; exit 1
        else
            echo "Installing object '$1'..."
            $CONF_DIR/objects/$1/install.sh
            echo "Done!"
        fi
esac

