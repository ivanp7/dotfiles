#!/bin/sh

CONF_DIR="$(realpath "$(dirname "$0")")"
UNINST_SCRIPT=$1

[ -d "$CONF_DIR/tree" ] || exit 0

install ()
{
    mkdir -p "$HOME/$(dirname $1)"
    cp -fT "$CONF_DIR/tree/$1" "$HOME/$1"
    chmod 644 "$HOME/$1"

    [ -n "$UNINST_SCRIPT" ] && echo 'delete_copied_file "'"$HOME/$1"'"' >> $UNINST_SCRIPT
}

add_directory_instruction ()
{
    [ -n "$UNINST_SCRIPT" ] && echo 'delete_empty_directory "'"$HOME/$1"'"' >> $UNINST_SCRIPT
}

[ -n "$UNINST_SCRIPT" ] &&
echo '
delete_copied_file ()
{
    [ -f "$1" ] && rm -f "$1"
}
' >> $UNINST_SCRIPT

for file in $(cd "$CONF_DIR/tree"; find . -type f | sort | sed 's,^\./,,')
do install $file; done

[ -n "$UNINST_SCRIPT" ] && echo >> $UNINST_SCRIPT

for dir in $(cd "$CONF_DIR/tree"; find . -type f | xargs -r dirname | 
    sort | uniq | sed '/^\.$/d; s,^\./,,')
do add_directory_instruction "$dir"; done

