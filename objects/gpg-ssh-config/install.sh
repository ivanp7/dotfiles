#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/.ssh/
chmod 700 $HOME/.ssh/
install -Dm 600 $CONF_DIR/config $HOME/.ssh/

mkdir -p $HOME/.gnupg/
chmod 700 $HOME/.gnupg/
install -Dm 600 $CONF_DIR/gpg.conf $CONF_DIR/gpg-agent.conf $HOME/.gnupg/

