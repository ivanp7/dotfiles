#!/bin/bash

. `dirname $0`/tmux-refresh-clients-functions.sh

while true
do
    # wait for TTY switch
    inotifywait -qq -e modify /sys/class/tty/tty0/active
    sleep 0.1
    refresh
done

