#!/bin/sh

MASTER=$(amixer -M sget Master)

state_level ()
{
    echo "$MASTER" | sed -E "/\s*$1:.*\[([0-9]+)%\].*\[(on|off)\].*/!d; s//\2 \1/" 2> /dev/null
}

STATE_LEVEL=$(state_level "Mono")
STATE=${STATE_LEVEL% *}
LEVEL=${STATE_LEVEL#* }

if [ -z "$STATE" ]
then
    STATE_LEVEL_LEFT=$(state_level "Front Left")
    STATE_LEVEL_RIGHT=$(state_level "Front Right")
    [ -z "$STATE_LEVEL_LEFT" -o -z "$STATE_LEVEL_RIGHT" ] && exit 1

    STATE_LEFT=${STATE_LEVEL_LEFT% *}
    STATE_RIGHT=${STATE_LEVEL_RIGHT% *}
    [ "$STATE_LEFT" = "on" -o "$STATE_RIGHT" = "on" ] && STATE="on" || STATE="off"

    LEVEL_LEFT=${STATE_LEVEL_LEFT#* }
    LEVEL_RIGHT=${STATE_LEVEL_RIGHT#* }
    LEVEL=$(( ($LEVEL_LEFT + $LEVEL_RIGHT) / 2 ))
fi

case $1 in
    "") echo "$LEVEL% $STATE" ;;
    toggle) 
        case "$STATE" in
            on) amixer -q sset Master mute ;;
            off) amixer -q sset Master unmute ;;
        esac
        ;;
    up) amixer -q -M sset Master 3%+ ;;
    down) amixer -q -M sset Master 3%- ;;
    *) amixer -q -M sset Master $1%
esac

