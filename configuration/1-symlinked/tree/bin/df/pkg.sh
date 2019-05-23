#!/bin/sh

AUR_HELPER=yay

if command -v $AUR_HELPER > /dev/null
then
    PKGMANAGER="$AUR_HELPER"
    PKGMANAGER_SUDO="$AUR_HELPER"
else
    PKGMANAGER="pacman"
    PKGMANAGER_SUDO="sudo pacman"
fi

MODE="$1"
shift 1

case $MODE in
    update) PKG_COMMAND="$PKGMANAGER_SUDO -Syu" ;;
    install) PKG_COMMAND="$PKGMANAGER_SUDO -S $@" ;;
    uninstall) PKG_COMMAND="$PKGMANAGER_SUDO -Rns $@" ;;
    uninstall-orphans) PKG_COMMAND="$PKGMANAGER_SUDO -Rns \$($PKGMANAGER -Qtdq)" ;;
    list) PKG_COMMAND="$PKGMANAGER -Qqet" ;;
    *)
        echo Error: unknown command "$1"
        exit 1
esac

echo $PKG_COMMAND
bash -c "$PKG_COMMAND"

