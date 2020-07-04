#!/bin/sh

sdcv --color "$@" | sed 's/\([[:digit:]]\+)\)/\n\n\1/g; s/;/;\n/g;'

