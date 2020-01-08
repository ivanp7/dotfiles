#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))
UNINST_SCRIPT=$1

install()
{
    mkdir -p "$HOME/$(dirname $1)"
    ln -sfT "$CONF_DIR/tree/$1" "$HOME/$1"

    [ -n "$UNINST_SCRIPT" ] && echo 'delete_symlink "'"$HOME/$1"'"' >> $UNINST_SCRIPT
}

[ -n "$UNINST_SCRIPT" ] &&
echo '
delete_symlink ()
{
    [ -L "$1" ] && rm "$1"
    delete_empty_directory_of "$1"
}
' >> $UNINST_SCRIPT

DIRECTORIES="$(sed 's,^,-path ./,; s,$, -prune -o ,' $CONF_DIR/directories | tr -d '\n')"
for file in $(cd $CONF_DIR/tree; find . $DIRECTORIES -type f -o -type l | sed 's,^\./,,')
do install $file; done

