#!/bin/sh

FILE="$1"
COLUMNS=$2
ROWS=$(($(tput lines) - 4))

mime_type=$(file --mime-type "$FILE" -bLE) || mime_type=""
case $mime_type in
    ""|inode/x-empty) ;;
    text/*) head -n $ROWS "$FILE" ;;
    *) echo "\033[0;7m$(file -bLE "$FILE")\033[0m"
esac

