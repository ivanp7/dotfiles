#!/bin/sh

sdcv.sh --color "$@" | sed 's/\([[:digit:]]\+)\)/\n\n\1/g; s/;/;\n/g;'

