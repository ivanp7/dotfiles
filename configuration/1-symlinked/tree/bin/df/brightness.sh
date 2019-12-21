#!/bin/sh

BACKLIGHT=$(find /sys/class/backlight -type l 2> /dev/null | head -n1)
if [ ! -d "$BACKLIGHT" ]; then exit 1; fi

BRIGHTNESS=$(cat $BACKLIGHT/actual_brightness)

MAX_BRIGHTNESS=$(cat $BACKLIGHT/max_brightness)
STEP=$(($MAX_BRIGHTNESS / 10))

case "$1" in
    "") echo "$BRIGHTNESS/$MAX_BRIGHTNESS ($((100 * $BRIGHTNESS / $MAX_BRIGHTNESS))%)" ;;
    up) echo $(($BRIGHTNESS + $STEP)) > $BACKLIGHT/brightness ;;
    down) echo $(($BRIGHTNESS - $STEP)) > $BACKLIGHT/brightness ;;
    *) echo "$1" > $BACKLIGHT/brightness ;;
esac

