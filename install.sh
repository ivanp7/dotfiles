#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

case $1 in
    "")
        echo "Installing everything:"
        for module in $(find $CONF_DIR/modules/ -mindepth 2 -maxdepth 2 -type f -name install.sh)
        do
            echo "Installing module '$(basename $(dirname $module))'..."
            $module
            # echo $module
        done
        echo "Done!"
        ;;

    *)
        if [ ! -x $CONF_DIR/modules/$1/install.sh ]
        then echo "Error: invalid module '$1'."; exit 1
        else
            echo "Installing module '$1'..."
            $CONF_DIR/modules/$1/install.sh
            echo "Done!"
        fi
esac

