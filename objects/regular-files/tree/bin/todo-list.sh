#!/bin/bash

OLD_LIST=$(basename $(readlink $HOME/Org/todo))

if [[ -z "$1" ]]
then
    echo $OLD_LIST
elif [[ -d "$HOME/Org/todo-lists/$1" ]]
then
    rm $HOME/Org/todo
    ln -sf todo-lists/$1 $HOME/Org/todo
    touch $HOME/Org/todo-lists/$OLD_LIST/todo.txt
else
    echo "No such TO-DO list '$1'."
fi
