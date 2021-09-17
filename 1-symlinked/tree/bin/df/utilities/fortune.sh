#!/bin/sh

command -v fortune > /dev/null || exit 0
command -v lolcat > /dev/null && LOLCAT=lolcat || LOLCAT=cat
{ [ -d "/usr/share/fortune/ru" ] && fortune ru || fortune -a; } | $LOLCAT
echo

