#!/bin/sh

UNINST_SCRIPT=$1

DIR=$HOME/.cache/tmux/plugins/tpm
[ -d $DIR ] || git clone https://github.com/tmux-plugins/tpm $DIR

[ -n "$UNINST_SCRIPT" ] &&
echo "
rm -rf \"$HOME/.cache/tmux/plugins\"
" >> $UNINST_SCRIPT

