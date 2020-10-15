#!/bin/sh

sdcv --utf8-input --utf8-output "$@" | sed 's/\([[:digit:]]\+)\)/\n\n\1/g; s/;/;\n/g;'

