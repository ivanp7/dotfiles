#!/bin/sh

if [ "$#" -ne 2 ]
then
    echo "Incorrect number of arguments supplied."
    echo "Expecting 2 arguments: SOURCE directory and TARGET directory."
    exit 1
fi

SOURCE_DIR="$(realpath "$1")"
TARGET_DIR="$2"

mkdir -p "$TARGET_DIR"
cp -rsP -t "$TARGET_DIR" "$SOURCE_DIR"

