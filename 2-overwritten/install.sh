#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))
UNINST_SCRIPT=$1

install()
{
    mkdir -p "$HOME/$(dirname $1)"
    cp -f "$CONF_DIR/tree/$1" "$HOME/$1"
    chmod 644 "$HOME/$1"

    [ -n "$UNINST_SCRIPT" ] && echo 'delete_copied_file "'"$HOME/$1"'"' >> $UNINST_SCRIPT
}

[ -n "$UNINST_SCRIPT" ] &&
echo '
delete_copied_file ()
{
    [ -f "$1" ] && rm "$1"
    delete_empty_directory_of "$1"
}
' >> $UNINST_SCRIPT

for file in $(cd $CONF_DIR/tree; find . -type f | sed 's,^\./,,')
do install $file; done

