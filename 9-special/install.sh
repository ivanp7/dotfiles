#!/bin/sh

CONF_DIR="$(realpath "$(dirname "$0")")"
UNINST_SCRIPT=$1

for instruction in $(find "$CONF_DIR/instructions" -mindepth 1 -maxdepth 1 -type f -name "*.sh" | sort)
do 
    echo ">> Installing '$(basename $instruction)'..."
    $instruction $UNINST_SCRIPT
done

