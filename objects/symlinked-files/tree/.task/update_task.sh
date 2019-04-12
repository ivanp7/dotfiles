#!/bin/sh

display()
{
    echo
    task next
}

display
while true
do
    inotifywait -qq -e move_self -e close_write $HOME/.task/pending.data
    sleep 0.3
    clear
    display
done

