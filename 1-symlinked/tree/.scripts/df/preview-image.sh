#!/bin/sh

command -v image2text > /dev/null || 
    { echo "Error: image2text is not available"; exit 1; }

image2text -r -x $(tput cols) -y $(tput lines) "$1"

