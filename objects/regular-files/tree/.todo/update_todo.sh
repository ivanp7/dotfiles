#!/bin/bash

display()
{
    echo
    todo.sh list
}

display
while true
do
    inotifywait -qq -e move_self -e close_write $HOME/org/todo/todo.txt
    sleep 0.3
    clear
    display
done

