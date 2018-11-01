#!/bin/bash

echo
todo.sh list
while true
do
    inotifywait -qq -e move_self -e close_write $HOME/Org/todo/todo.txt
    sleep 0.5
    clear
    echo
    todo.sh list
done

