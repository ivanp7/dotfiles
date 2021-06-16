#!/bin/sh

tmp="$1"
shift 1

[ -f "$tmp" ] && lf -last-dir-path="$tmp" "$@" || lf "$@"

