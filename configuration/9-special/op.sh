#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

for category in $(find $CONF_DIR/instructions -mindepth 1 -maxdepth 1 -type f -name "*.sh")
do $category $1; done

