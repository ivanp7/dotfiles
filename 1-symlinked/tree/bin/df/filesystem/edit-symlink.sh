#!/bin/sh

if [ -L "$1" ]
then
    LINK_PATH="$(readlink "$1")"
    rm -- "$1"
    ln -s -T "$(echo "$LINK_PATH" | vipe)" "$1"
fi

