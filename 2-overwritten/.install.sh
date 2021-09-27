cp -rf --preserve=mode -T -- ./tree "$INSTALLATION_DIRECTORY/overwritten"

echo '
[ -d "overwritten" ] || {
    echo "Missing overwritten configuration files"
    exit 1
}

install_overwritten ()
{
    mkdir -p -- "$HOME/$(dirname -- "$1")"
    cp -fT --preserve=mode -- "$DOTFILES/overwritten/$1" "$HOME/$1"

    echo "uninstall_overwritten $(guard_path "$HOME/$1")" >> "$UNINSTALLER"
}

echo "
uninstall_overwritten ()
{
    [ -f \"\$1\" ] && rm -f -- \"\$1\"
}
" >> "$UNINSTALLER"
' >> "$INSTALLATION_DIRECTORY/install.sh"

for file in $(cd tree; find . -type f | sort | sed 's,^\./,,')
do
    echo "install_overwritten $(guard_path "$file")" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

for dir in $(cd tree; find . -type f | xargs -r dirname | sort -r | uniq | sed '/^\.$/d; s,^\./,,')
do
    echo "add_directory_uninstallation_instruction $(guard_path "$dir")" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

