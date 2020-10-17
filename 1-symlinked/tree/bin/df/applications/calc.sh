#!/bin/sh

mispipe "$(echo octave-cli --eval \""$@"\")" "sed 's/^.*= *//'"

