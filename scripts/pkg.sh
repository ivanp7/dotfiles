#!/bin/bash

AUR_HELPER=yay

if type $AUR_HELPER > /dev/null
then
    PKGMANAGER="$AUR_HELPER"
    PKGMANAGER_SUDO="$AUR_HELPER"
else
    PKGMANAGER="pacman"
    PKGMANAGER_SUDO="sudo pacman"
fi

case $1 in
    update) PKG_COMMAND="$PKGMANAGER_SUDO -Syu" ;;
    install) PKG_COMMAND="$PKGMANAGER_SUDO -S ${@:2}" ;;
    uninstall) PKG_COMMAND="$PKGMANAGER_SUDO -Rns ${@:2}" ;;
    uninstall-orphans) PKG_COMMAND="$PKGMANAGER_SUDO -Rns \$($PKGMANAGER -Qtdq)" ;;
    list) PKG_COMMAND="$PKGMANAGER -Qqet" ;;
    *)
        echo Error: unknown command "$1"
        exit 1
esac

echo $PKG_COMMAND
bash -c "$PKG_COMMAND"

