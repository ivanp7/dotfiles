#!/bin/sh

CACHE=$(mktemp /tmp/thumb_cache.XXXXX.png)
ffmpegthumbnailer -i "$1" -o $CACHE -s 0 -c png
$(dirname "$0")/preview-image.sh $CACHE && rm $CACHE

