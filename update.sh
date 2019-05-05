#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

cd $CONF_DIR
./uninstall.sh
git pull
./install.sh

