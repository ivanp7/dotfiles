#!/bin/bash

TMUX_STATUS_INTERVAL=1

while true
do
    inotifywait -qq -e modify /sys/class/tty/tty0/active
    sleep 0.1
    TTY=$(cat /sys/class/tty/tty0/active)

    if [[ -f "$HOME/.tmux_tmp/$TTY" ]]
    then
        PTS=$(cat $HOME/.tmux_tmp/$TTY)

        if [[ -z $PTS ]]
        then
            tmux set -g status-interval $TMUX_STATUS_INTERVAL
        else
            for client in $(tmux list-clients 2> /dev/null | grep yaft-256color | cut -d':' -f1)
            do
                if [[ $PTS == $client ]]
                then
                    tmux set -g status-interval $TMUX_STATUS_INTERVAL
                    tmux refresh-client -t $client
                    break
                fi
            done
        fi
    elif [[ -z $PREVTTY ]] || [[ -f "$HOME/.tmux_tmp/$PREVTTY" ]]
    then
        tmux set -g status-interval 0
        sudo chvt 13
        sleep 0.1
        sudo chvt ${TTY:3}
    fi

    PREVTTY=$TTY
done

