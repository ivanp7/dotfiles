#!/bin/sh

sed -i "s/USERNAME/$USER/g" $HOME/.config/octave/octaverc
mkdir -p $HOME/.local/share/octave

