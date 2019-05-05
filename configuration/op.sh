#!/bin/sh

CONF_DIR=$(realpath `dirname $0`)

for category in $(find $CONF_DIR -mindepth 1 -maxdepth 1 -type d | sort)
do $category/op.sh $1; done

