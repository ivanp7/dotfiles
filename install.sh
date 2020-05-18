#!/bin/sh

CONF_DIR="$(realpath "$(dirname "$0")")"
UNINST_SCRIPT=$HOME/.uninstall-dotfiles.sh

if [ -f "$UNINST_SCRIPT" ]
then
    echo 'dotfiles seems to be already installed!'
    exit 1
fi

echo '#!/bin/sh' > $UNINST_SCRIPT
chmod 744 $UNINST_SCRIPT

echo '
delete_empty_directory ()
{
    [ -d "$1" ] && rmdir --ignore-fail-on-non-empty -p "$1"
}
' >> $UNINST_SCRIPT

for category in $(find "$CONF_DIR" -mindepth 1 -maxdepth 1 -type d \! -name ".git" | sort)
do 
    $category/install.sh $UNINST_SCRIPT
    echo >> $UNINST_SCRIPT
done

echo '
rm -f "'"$UNINST_SCRIPT"'"
' >> $UNINST_SCRIPT

