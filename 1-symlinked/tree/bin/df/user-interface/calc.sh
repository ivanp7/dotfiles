#!/bin/sh

octave-cli --eval "$@" 2> /dev/null | sed 's/^.*= *//'

