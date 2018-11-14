#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

cp -f $CONF_DIR/.gitconfig $HOME/
chmod 644 $HOME/.gitconfig
sed -i "s/USERNAME/$(whoami)/g" $HOME/.gitconfig
sed -i "s@HOME@$HOME@g" $HOME/.gitconfig

