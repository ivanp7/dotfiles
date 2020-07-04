#!/bin/sh

LINK="$1"

if [ ! -L "$LINK" ]
then
    echo "'$LINK' is not a symlink."
    exit 1
fi

LINK_PATH="$(readlink "$LINK")"

if [ ! -d "$LINK_PATH" ]
then
    exit 0
fi

DIR="$(dirname "$LINK")"
NAME="$(basename "$LINK")"

cd "$DIR"
rm "$NAME"
mkdir "$NAME"

case "$LINK_PATH" in
    /*) find "$LINK_PATH/" -mindepth 1 -maxdepth 1 | xargs -I {} ln -s "{}" "$NAME/" ;;
    *) find "$LINK_PATH/" -mindepth 1 -maxdepth 1 | xargs -I {} ln -s "../{}" "$NAME/" ;;
esac

