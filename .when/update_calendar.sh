#!/bin/bash

display()
{
    echo
    when ci
}

display
while true
do
    inotifywait -qq -e delete_self -e close_write $HOME/Org/calendar
    sleep 0.3
    clear
    display
done

