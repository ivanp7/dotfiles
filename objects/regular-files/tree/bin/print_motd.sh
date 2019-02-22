#!/bin/bash

[[ $(tput colors) -ge 256 ]] && im2a -p -W $(tput cols) -H $(($(tput lines))) $HOME/.motd_pic
echo
echo
echo
neofetch
echo

