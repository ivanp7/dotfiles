#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

cat $CONF_DIR/directories | while read dir
do
    [ -d $HOME/$(dirname $dir) ] || mkdir -p $HOME/$(dirname $dir)
    ln -sf $CONF_DIR/tree/$dir $HOME/$(dirname $dir)/
done

[ -x $CONF_DIR/special-instructions.sh ] && $CONF_DIR/special-instructions.sh || true

