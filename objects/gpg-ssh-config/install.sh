#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/.ssh/
chmod 700 $HOME/.ssh/
cp -f $CONF_DIR/config $HOME/.ssh/
chmod 600 $HOME/.ssh/config

mkdir -p $HOME/.gnupg/
chmod 700 $HOME/.gnupg/
cp -f $CONF_DIR/gpg.conf $CONF_DIR/gpg-agent.conf $HOME/.gnupg/
chmod 600 $HOME/.gnupg/gpg.conf $HOME/.gnupg/gpg-agent.conf

