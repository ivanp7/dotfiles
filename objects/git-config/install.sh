#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

install -Dm 644 $CONF_DIR/.gitconfig $HOME/
sed -i "s/USERNAME/$(whoami)/g" $HOME/.gitconfig
sed -i "s@HOME@$HOME@g" $HOME/.gitconfig

