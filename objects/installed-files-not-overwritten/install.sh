#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

cp -rnT $CONF_DIR/tree $HOME

[ -x $CONF_DIR/special-instructions.sh ] && $CONF_DIR/special-instructions.sh || true

