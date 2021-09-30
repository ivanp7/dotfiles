#!/bin/sh

guard_path ()
{
    echo "'$(echo "$1" | sed "s/'/'\"'\"'/g")'"
}

DIR="$HOME/.cache/tmux/plugins/tpm"
[ -d "$DIR" ] || git clone "https://github.com/tmux-plugins/tpm" "$DIR"

echo "
rm -rf -- $(guard_path "$HOME/.cache/tmux/plugins")
" >> "$1"

