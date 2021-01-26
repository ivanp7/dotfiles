#!/bin/sh

SINKS=$(pactl list short sinks | sed 's/\s.*//')

get_state_and_level ()
{
    SINK_INFO=$(pactl list sinks | grep -A 11 "^Sink #$1$")

    SINK_STATUS=$(echo "$SINK_INFO" | grep "^\s*State: " | sed 's/[^:]*: //' | head -c 3)
    [ "$SINK_STATUS" != "RUN" ] && SINK_STATUS=$(echo "$SINK_STATUS" | tr 'A-Z' 'a-z')

    SINK_MUTE=$(echo "$SINK_INFO" | grep "^\s*Mute: " | sed 's/[^:]*: //')
    case "$SINK_MUTE" in
        no) STATE="on" ;;
        yes) STATE="off" ;;
    esac

    SINK_VOLUME=$(echo "$SINK_INFO" | grep "^\s*Volume: " | sed 's/[^:]*: //')
    SINK_VOLUME_FRONT_LEFT=$(echo "$SINK_VOLUME" | sed -E 's/.*front-left:[^:]*\/\s*([0-9]*)%\s*\/.*/\1/')
    SINK_VOLUME_FRONT_RIGHT=$(echo "$SINK_VOLUME" | sed -E 's/.*front-right:[^:]*\/\s*([0-9]*)%\s*\/.*/\1/')

    [ "$SINK_VOLUME_FRONT_LEFT" = "$SINK_VOLUME_FRONT_RIGHT" ] && 
        LEVEL="$SINK_VOLUME_FRONT_LEFT" ||
        LEVEL="$SINK_VOLUME_FRONT_LEFT/$SINK_VOLUME_FRONT_RIGHT"

    echo "($SINK_STATUS#$1): $LEVEL% $STATE"
}

for s in $SINKS
do
    case $1 in
        "") get_state_and_level $s ;;
        toggle) pactl set-sink-mute $s toggle ;;
        up) pactl set-sink-volume $s +3% ;;
        down) pactl set-sink-volume $s -3% ;;
        *) pactl set-sink-volume $s $1% ;;
    esac
done

