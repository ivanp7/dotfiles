#!/bin/sh

grep -sq "^hsts-file =" "$HOME/.config/wgetrc" ||
    { echo "hsts-file = $HOME/.cache/wget-hsts" >> "$HOME/.config/wgetrc"; }

