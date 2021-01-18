#!/bin/sh

CONF_DIR="$(realpath "$(dirname "$0")")"

[ -d "$CONF_DIR/tree" ] || exit 0

install ()
{
    if [ ! -f "$HOME/$1" ]
    then
        mkdir -p "$HOME/$(dirname $1)"
        cp -nT "$CONF_DIR/tree/$1" "$HOME/$1"
        chmod 644 "$HOME/$1"
    fi
}

for file in $(cd "$CONF_DIR/tree"; find . -type f | sort | sed 's,^\./,,')
do install $file; done

