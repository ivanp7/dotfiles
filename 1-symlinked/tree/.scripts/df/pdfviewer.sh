#!/bin/sh

pdftotext -layout "$@" - | exec "$PAGER"

