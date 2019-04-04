#!/bin/bash

[[ $(tput colors) -ge 256 ]] && pixterm -tc $(tput cols) -tr $(($(tput lines) / 2)) $HOME/.motd_pic
echo
echo
echo
neofetch
echo

