#!/bin/sh

if [ "$(id -u)" -ne 0 ]
then
    echo "This script must be run under root. Terminating..."
    exit 1
fi

cd -- "$(dirname -- "$0")"
SCRIPT_DIRECTORY="$PWD"

if [ -n "$1" ]
then
    if [ ! -d "plugins/$1" ]
    then
        echo "Plugin '$1' does not exist. Terminating..."
        exit 1
    fi

    NAME="$1"
    cd "plugins/$1"
fi

: ${NAME:="dotfiles"}
: ${INSTALLATION_DIRECTORY:="/usr/local/share/$NAME"}
: ${HOME_DOTFILES_PATH:=".local/share/$NAME"}
: ${HOME_UNINSTALLER_PATH:=".local/share/uninstall-$NAME.sh"}

if [ -d "$INSTALLATION_DIRECTORY" ]
then
    echo "Installation directory '$INSTALLATION_DIRECTORY' already exist. Terminating..."
    exit 1
fi

PLUGIN_DIRECTORY="$PWD"

guard_path ()
{
    echo "'$(echo "$1" | sed "s/'/'\"'\"'/g")'"
}

mkdir -p -- "$INSTALLATION_DIRECTORY"

echo "#!/bin/sh
exec \"\$HOME\"/$(guard_path "$HOME_UNINSTALLER_PATH")
" > "$INSTALLATION_DIRECTORY/uninstall.sh"
chmod 755 "$INSTALLATION_DIRECTORY/uninstall.sh"

echo "#!/bin/sh
cd -- \"\$(dirname \"\$0\")\"

guard_path ()
{
    echo \"'\$(echo \"\$1\" | sed \"s/'/'\\\"'\\\"'/g\")'\"
}

DOTFILES=\"\$HOME\"/$(guard_path "$HOME_DOTFILES_PATH")
UNINSTALLER=\"\$HOME\"/$(guard_path "$HOME_UNINSTALLER_PATH")

[ -f \"\$UNINSTALLER\" ] && {
    echo \"$NAME seems to be already installed!\"
    exit 1
}

mkdir -p -- \"\$(dirname -- \"\$DOTFILES\")\"
ln -sfT -- \"$INSTALLATION_DIRECTORY\" \"\$DOTFILES\"
" > "$INSTALLATION_DIRECTORY/install.sh"
chmod 755 "$INSTALLATION_DIRECTORY/install.sh"

echo '
mkdir -p -- "$(dirname -- "$UNINSTALLER")"
echo "#!/bin/sh" > "$UNINSTALLER"
chmod 755 "$UNINSTALLER"

add_directory_uninstallation_instruction ()
{
    echo "uninstall_directory_if_empty $(guard_path "$HOME/$1")" >> "$UNINSTALLER"
}

echo "
uninstall_directory_if_empty ()
{
    [ -d \"\$1\" ] && rmdir --ignore-fail-on-non-empty -p -- \"\$1\"
}
" >> "$UNINSTALLER"

' >> "$INSTALLATION_DIRECTORY/install.sh"

for category in $(find . -mindepth 1 -maxdepth 1 -type d \! -name ".git" \! -name "plugins" | sort)
do
    cd -- "$PLUGIN_DIRECTORY/$category"
    CATEGORY_INSTALLER="./.install.sh"
    if [ -f "$CATEGORY_INSTALLER" ]
    then . "$CATEGORY_INSTALLER"
    else
        CATEGORY_INSTALLER="$SCRIPT_DIRECTORY/$category/.install.sh"
        if [ -f "$CATEGORY_INSTALLER" ]
        then . "$CATEGORY_INSTALLER"
        else echo "Installer is not available for $category in $NAME"
        fi
    fi
done

echo '
echo "
rm -f -- $(guard_path "$DOTFILES")
rm -f -- \"\$(realpath -- \"\$0\")\"
" >> "$UNINSTALLER"
' >> "$INSTALLATION_DIRECTORY/install.sh"

