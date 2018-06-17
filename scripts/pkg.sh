#!/bin/bash

if type trizen > /dev/null
then
    PKGMANAGER="aurman"
    PKGMANAGER_SUDO="aurman"
else
    PKGMANAGER="pacman"
    PKGMANAGER_SUDO="sudo pacman"
fi

if [[ "$1" == "update" ]]
then
    PKG_COMMAND="$PKGMANAGER_SUDO -Syu"
elif [[ "$1" == "install" ]]
then
    PKG_COMMAND="$PKGMANAGER_SUDO -S ${@:2}"
elif [[ "$1" == "remove" ]]
then
    PKG_COMMAND="$PKGMANAGER_SUDO -Rns ${@:2}"
elif [[ "$1" == "remove-orphans" ]]
then
    PKG_COMMAND="$PKGMANAGER_SUDO -Rns \$($PKGMANAGER -Qtdq)"
elif [[ "$1" == "list" ]]
then
    PKG_COMMAND="$PKGMANAGER -Qqet"
else
    echo Error: unknown command "$1"
    exit 1
fi

echo $PKG_COMMAND
bash -c "$PKG_COMMAND"

