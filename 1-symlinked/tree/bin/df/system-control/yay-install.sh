#!/bin/sh

: "${AUR_PKG_URL:=https://aur.archlinux.org/packages.gz}"

PACKAGES="$({ pacman -Slq; curl --fail --silent "$AUR_PKG_URL" | gunzip --stdout | tail -n +2; } |
    fzf --prompt='Packages: ' --preview='yay -Si {}' --preview-window=right:wrap --layout=reverse)"
[ -n "$PACKAGES" ] && yay -S $(echo $PACKAGES) || echo "Installation cancelled"

