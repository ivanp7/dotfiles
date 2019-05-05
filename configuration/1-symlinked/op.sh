#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))

install()
{
    mkdir -p "$HOME/$(dirname $1)"
    ln -sf "$CONF_DIR/tree/$1" "$HOME/$1"
}

uninstall()
{
    [ -L "$HOME/$1" ] && rm "$HOME/$1"

    DIR="$(dirname "$HOME/$1")"
    while [ "$(find "$DIR" -mindepth 1 -maxdepth 1 2> /dev/null | wc -l)" -eq 0 ]
    do
        [ -d "$DIR" ] && rm -d "$DIR"
        DIR="$(dirname "$DIR")"
    done
}

case $1 in
    i) OP=install ;;
    u) OP=uninstall ;;
    *) exit 1 ;;
esac

DIRECTORIES="$(sed 's,^,-path ./,; s,$, -prune -o ,' $CONF_DIR/directories | tr -d '\n')"
for file in $(cd $CONF_DIR/tree; find . $DIRECTORIES -type f | sed 's,^\./,,')
do $OP $file; done

