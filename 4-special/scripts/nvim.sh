#!/bin/sh

guard_path ()
{
    echo "'$(echo "$1" | sed "s/'/'\"'\"'/g")'"
}

PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
curl -fLo "$PLUG_VIM" --create-dirs \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
mkdir -p -- "$HOME/.local/share/nvim/backup"

echo "
rm -f -- $(guard_path "$PLUG_VIM")
rm -rf -- $(guard_path "$HOME/.cache/nvim/plugged")
" >> "$1"

