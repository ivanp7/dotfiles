#!/bin/sh

if ! mime_type=$(file --mime-type "$1" -bLE); then mime_type=""; fi
case $mime_type in
    "") ;;
    image/*) $HOME/.scripts/df/preview-image.sh "$(realpath "$1")" ;;
    video/*) $HOME/.scripts/df/preview-video-thumbnail.sh "$(realpath "$1")" ;;
esac

