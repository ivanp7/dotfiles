#!/bin/sh

STATE=$(amixer sget Master | grep 'Mono:' | sed -E 's/.*\[(on|off)\].*/\1/')
LEVEL=$(amixer -M sget Master | grep 'Mono:' | sed -E 's/.*\[(.*)%\].*/\1/')

case $1 in
    "") echo "$LEVEL% $STATE" ;;
    toggle) 
        if [ "$STATE" = "on" ]
        then
            amixer -q sset Master mute
            amixer -q sset Speaker mute
            amixer -q sset Headphone mute
        elif [ "$STATE" = "off" ]
        then
            amixer -q sset Master unmute
            amixer -q sset Speaker unmute
            amixer -q sset Headphone unmute
        fi
        ;;
    up) amixer -q -M sset Master 3%+ ;;
    down) amixer -q -M sset Master 3%- ;;
    *) amixer -q -M sset Master $1%
esac

amixer -q -M sset Speaker 100%
amixer -q -M sset Headphone 100%

