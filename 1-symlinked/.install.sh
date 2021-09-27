cp -rf --preserve=mode -T -- ./tree "$INSTALLATION_DIRECTORY/symlinked"

echo '
[ -d "symlinked" ] || {
    echo "Missing symlinked configuration files"
    exit 1
}

install_symlink ()
{
    mkdir -p -- "$HOME/$(dirname -- "$1")"
    ln -sfT -- "$DOTFILES/symlinked/$1" "$HOME/$1"

    echo "uninstall_symlink $(guard_path "$HOME/$1")" >> "$UNINSTALLER"
}

echo "
uninstall_symlink ()
{
    [ -L \"\$1\" ] && rm -f -- \"\$1\"
}
" >> "$UNINSTALLER"
' >> "$INSTALLATION_DIRECTORY/install.sh"

DIRECTORIES=
[ -f "directories" ] && DIRECTORIES="$(sed 's,^,-path ./,; s,$, -prune -o ,' "directories" | tr -d '\n')"

for file in $(cd tree; find . $DIRECTORIES -type f | sort | sed 's,^\./,,')
do
    echo "install_symlink $(guard_path "$file")" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

for dir in $(cd tree; find . $DIRECTORIES -type f | xargs -r dirname | sort -r | uniq | sed '/^\.$/d; s,^\./,,')
do
    echo "add_directory_uninstallation_instruction $(guard_path "$dir")" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

