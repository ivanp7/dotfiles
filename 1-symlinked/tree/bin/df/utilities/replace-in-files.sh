#!/bin/sh
set -e

PATTERN="$1"
REPLACEMENT="$2"
shift 2

SED_CHAR="/"
[ "$#" -gt 0 ] && { SED_CHAR="$1"; shift 1; }

rg "$@" -l -e "$PATTERN" | xargs -r sed -i -E -e "s${SED_CHAR}${PATTERN}${SED_CHAR}${REPLACEMENT}${SED_CHAR}g"

