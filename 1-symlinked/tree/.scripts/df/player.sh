#!/bin/sh

exec mpv --vo=tct --vo-tct-width=$(tput cols) --vo-tct-height=$(tput lines) --vo-tct-256=yes --really-quiet "$@"

