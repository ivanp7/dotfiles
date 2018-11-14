#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/.ssh/
chmod 700 $HOME/.ssh/
cp -f $CONF_DIR/config $HOME/.ssh/
chmod 644 $HOME/.ssh/config

