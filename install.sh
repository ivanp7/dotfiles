#!/bin/sh

CONF_DIR=$(realpath $(dirname $0))
UNINST_SCRIPT=$HOME/.uninstall-dotfiles.sh

if [ -f "$UNINST_SCRIPT" ]
then
    echo 'dotfiles seems to be already installed!'
    exit 1
fi

echo '#!/bin/sh' > $UNINST_SCRIPT
chmod 744 $UNINST_SCRIPT

echo '
delete_empty_directory_of ()
{
    if [ -d "$1" ]
    then local DIR="$1"
    else local DIR=$(dirname "$1")
    fi

    [ -d "$DIR" ] || return

    if [ -z "$(find "$DIR" -mindepth 1 -maxdepth 1 2> /dev/null)" ]
    then 
        rm -d "$DIR"
        delete_empty_directory_of "$(dirname "$DIR")"
    fi
}
' >> $UNINST_SCRIPT

for category in $(find $CONF_DIR -mindepth 1 -maxdepth 1 -type d \! -name ".git" | sort)
do 
    $category/install.sh "$UNINST_SCRIPT"
    echo >> $UNINST_SCRIPT
done

echo 'rm "'"$UNINST_SCRIPT"'"' >> $UNINST_SCRIPT

