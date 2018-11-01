#!/bin/bash

echo
when ci
while true
do
    inotifywait -qq -e delete_self -e close_write $HOME/Org/calendar
    sleep 0.1
    clear
    echo
    when ci
done

