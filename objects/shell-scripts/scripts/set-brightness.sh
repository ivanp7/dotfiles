#!/bin/sh

if [ ! -d /sys/class/backlight ]; then exit 1; fi

BACKLIGHT=$(basename $(find /sys/class/backlight -type l | head -n1))

echo Max brightness: $(cat /sys/class/backlight/$BACKLIGHT/max_brightness)
if [ -n "$1" ]; then echo $1 | sudo tee /sys/class/backlight/$BACKLIGHT/brightness > /dev/null; fi
echo Current brighness: $(cat /sys/class/backlight/$BACKLIGHT/actual_brightness)

