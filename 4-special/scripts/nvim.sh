#!/bin/sh

guard_path ()
{
    echo "'$(echo "$1" | sed "s/'/'\"'\"'/g")'"
}

PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
[ -f "$PLUG_VIM" ] && rm -f -- "$PLUG_VIM"
curl -fLo "$PLUG_VIM" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

PAGER_AUTOLOAD_DIR="$HOME/.local/share/nvimpager/site/autoload"
mkdir -p -- "$PAGER_AUTOLOAD_DIR"
ln -sf -t "$PAGER_AUTOLOAD_DIR" "$PLUG_VIM"

mkdir -p -- "$HOME/.local/share/nvim/backup"

