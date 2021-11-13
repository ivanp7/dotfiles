#!/bin/sh

FILE="$1"
COLUMNS=$2
ROWS=$3

mime_type=$(file --mime-type "$FILE" -bLE) || mime_type=""
case $mime_type in
    ""|inode/x-empty) ;;
    text/*|application/json) head -n $ROWS "$FILE" ;;
    *) echo "\033[0;7m$(file -bLE "$FILE")\033[0m"
esac

