cp -rf --preserve=mode -T -- ./tree "$INSTALLATION_DIRECTORY/supplemented"

echo '
[ -d "supplemented" ] || {
    echo "Missing supplemented configuration files"
    exit 1
}

install_supplemented ()
{
    [ -f "$HOME/$1" ] && return

    mkdir -p -- "$HOME/$(dirname -- "$1")"
    cp -nT --preserve=mode -- "$DOTFILES/supplemented/$1" "$HOME/$1"
}
' >> "$INSTALLATION_DIRECTORY/install.sh"

for file in $(cd tree; find . -type f | sort | sed 's,^\./,,')
do
    echo "install_supplemented $(guard_path "$file")" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

