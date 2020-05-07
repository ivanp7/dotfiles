#!/bin/sh

CACHE=$(mktemp /tmp/thumb_cache.XXXXX)
ffmpegthumbnailer -i "$1" -o $CACHE -s 0
$(dirname "$0")/preview-image.sh $CACHE && rm $CACHE

