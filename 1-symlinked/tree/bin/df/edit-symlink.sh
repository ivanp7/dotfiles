#!/bin/sh

if [ -L "$1" ]
then
    OLD_PATH=$(readlink "$1")
    rm "$1"
    ln -s $(echo "$OLD_PATH" | vipe) "$1"
fi

