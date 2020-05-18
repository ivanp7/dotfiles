#!/bin/sh

CONF_DIR="$(realpath "$(dirname "$0")")"
UNINST_SCRIPT=$1

for category in $(find "$CONF_DIR/instructions" -mindepth 1 -maxdepth 1 -type f -name "*.sh" | sort)
do $category $UNINST_SCRIPT; done

