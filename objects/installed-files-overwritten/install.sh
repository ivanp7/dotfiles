#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

cp -rfT $CONF_DIR/tree $HOME

[ -x $CONF_DIR/special-instructions.sh ] && $CONF_DIR/special-instructions.sh || true

