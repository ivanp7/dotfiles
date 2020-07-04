#!/bin/sh

state ()
{
    amixer sget Master | sed -E "/.*$1:.*\[(on|off)\].*/!d;s//\1/" 2> /dev/null
}

level ()
{
    amixer -M sget Master | sed -E "/.*$1:.*\[(.*)%\].*/!d;s//\1/" 2> /dev/null
}

STATE=$(state "Mono")
LEVEL=$(level "Mono")

if [ -z "$STATE" ]
then
    STATE_LEFT=$(state "Front Left")
    STATE_RIGHT=$(state "Front Right")
    if [ "$STATE_LEFT" = "on" ] || [ "$STATE_RIGHT" = "on" ]
    then STATE="on"
    else STATE="off"
    fi
    LEVEL_LEFT=$(level "Front Left")
    LEVEL_RIGHT=$(level "Front Right")
    LEVEL=$(( ($LEVEL_LEFT + $LEVEL_RIGHT) / 2 ))
fi

case $1 in
    "") echo "$LEVEL% $STATE" ;;
    toggle) 
        if [ "$STATE" = "on" ]
        then
            amixer -q sset Master mute
            amixer -q sset Speaker mute 2> /dev/null
            amixer -q sset Headphone mute 2> /dev/null
        elif [ "$STATE" = "off" ]
        then
            amixer -q sset Master unmute
            amixer -q sset Speaker unmute 2> /dev/null
            amixer -q sset Headphone unmute 2> /dev/null
        fi
        ;;
    up) amixer -q -M sset Master 3%+ ;;
    down) amixer -q -M sset Master 3%- ;;
    calibrate)
        amixer -q -M sset Speaker 100% 2> /dev/null
        amixer -q -M sset Headphone 100% 2> /dev/null
        ;;
    *) amixer -q -M sset Master $1%
esac


