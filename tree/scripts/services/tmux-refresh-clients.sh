#!/bin/bash

UNUSED_VT=13

TMUX_STATUS_INTERVAL=$(tmux show-options -g status-interval | cut -d' ' -f2)

list_clients()
{
    tmux list-clients 2> /dev/null | grep yaft-256color
}

find_client()
{
    if [[ -f "$HOME/.tmux_tmp/$TTY" ]]
    then
        local PTS=$(cat $HOME/.tmux_tmp/$1)
        local CLIENT=$(list_clients | grep $PTS)
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

while true
do
    inotifywait -qq -e modify /sys/class/tty/tty0/active
    sleep 0.1
    TTY=$(cat /sys/class/tty/tty0/active)
    CLIENT=$(find_client $TTY)

    if [[ -n $CLIENT ]]
    then
        tmux set -t $(client_session $CLIENT) status-interval $TMUX_STATUS_INTERVAL
        sleep 0.3
        tmux refresh-client -t $(client_pts $CLIENT)
    elif [[ ! -f "$HOME/.tmux_tmp/$TTY" ]]
    then
        for client in $(list_clients)
        do
            tmux set -t $client status-interval 0
        done

        sudo chvt $UNUSED_VT
        sleep 0.3
        sudo chvt ${TTY:3}
    fi

    PREV_TTY=$TTY
done

