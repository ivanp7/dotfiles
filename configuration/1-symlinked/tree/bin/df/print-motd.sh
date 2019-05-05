#!/bin/sh

[ "$(tput colors)" -ge 256 ] && [ -f "$HOME/.motd_pic" ] && pixterm -tc $(tput cols) -tr $(($(tput lines) / 2)) $HOME/.motd_pic
echo
echo
echo
neofetch
echo

