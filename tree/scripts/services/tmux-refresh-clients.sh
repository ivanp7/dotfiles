#!/bin/bash

UNUSED_VT=13

TMUX_STATUS_INTERVAL=$(tmux show-options -g status-interval | cut -d' ' -f2)

find_client()
{
    if [[ -f "$HOME/.tmux_tmp/$TTY" ]]
    then
        local PTS=$(cat $HOME/.tmux_tmp/$1)
        local CLIENT=$(tmux list-clients 2> /dev/null | grep yaft-256color | grep $PTS)
        echo $CLIENT
    fi
}

client_pts()
{
    echo $1 | cut -d':' -f1
}

client_session()
{
    echo $1 | cut -d' ' -f2
}

PREV_TTY=$(cat /sys/class/tty/tty0/active)
PREV_CLIENT=$(find_client $PREV_TTY)

while true
do
    inotifywait -qq -e modify /sys/class/tty/tty0/active
    sleep 0.1
    TTY=$(cat /sys/class/tty/tty0/active)
    CLIENT=$(find_client $TTY)

    if [[ -n $PREV_CLIENT ]]
    then
        tmux set -t $(client_session $PREV_CLIENT) status-interval 0
    fi

    if [[ -n $CLIENT ]]
    then
        tmux set -t $(client_session $CLIENT) status-interval $TMUX_STATUS_INTERVAL
        sleep 0.2
        tmux refresh-client -t $(client_pts $CLIENT)
    else
        sudo chvt $UNUSED_VT
        sleep 0.3
        sudo chvt ${TTY:3}
    fi

    PREV_TTY=$TTY
    PREV_CLIENT=$CLIENT
done

