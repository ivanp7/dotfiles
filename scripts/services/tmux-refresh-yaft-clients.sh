#!/bin/bash

while true
do
    for client in $(tmux list-clients 2> /dev/null | grep yaft-256color | cut -d':' -f1)
    do
        tmux refresh-client -t $client
    done
    sleep 0.5
done

