#!/bin/sh

UNINST_SCRIPT=$1

PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
curl -fLo "$PLUG_VIM" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p $HOME/.local/share/nvim/backup

[ -n "$UNINST_SCRIPT" ] &&
echo "
rm -f \"$PLUG_VIM\"
rm -rf \"$HOME/.cache/nvim/plugged\"
" >> $UNINST_SCRIPT

