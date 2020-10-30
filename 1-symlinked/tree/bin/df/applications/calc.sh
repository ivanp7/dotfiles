#!/bin/sh

exec mispipe "$(echo octave-cli --eval \""$@"\")" "sed 's/^.*= *//'"

