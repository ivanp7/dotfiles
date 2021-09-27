cp -rf --preserve=mode -T -- ./scripts "$INSTALLATION_DIRECTORY/scripts"

echo '
[ -d "scripts" ] || {
    echo "Missing special configuration scripts"
    exit 1
}
' >> "$INSTALLATION_DIRECTORY/install.sh"

for script in $(cd scripts; find . -mindepth 1 -maxdepth 1 -type f -name "*.sh" | sort | sed 's,^\./,,')
do
    echo "\"\$DOTFILES/scripts/\"$(guard_path "$script") \"\$UNINSTALLER\"" >> "$INSTALLATION_DIRECTORY/install.sh"
done
echo >> "$INSTALLATION_DIRECTORY/install.sh"

