#!/bin/sh

DIR=$(realpath $(dirname $0)/../../1-symlinked/tree/.tmux/plugins/tpm)
if [ ! -d $DIR ]
then git clone https://github.com/tmux-plugins/tpm $DIR; fi

