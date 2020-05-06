#!/bin/sh

NAME="$(basename "$(realpath "$1")")"

tar -cvf "$NAME.tar" "$1" > /dev/null 2>&1
gpg --armor --symmetric "$NAME.tar"
rm "$NAME.tar"

