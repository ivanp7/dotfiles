#!/bin/sh

command -v fortune > /dev/null || exit 0
{ [ -d "/usr/share/fortune/ru" ] && fortune ru || fortune -a; } | lolcat
echo

