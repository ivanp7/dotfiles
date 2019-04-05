#!/bin/bash

OLD_LIST=$(basename $(readlink $HOME/org/todo))

if [[ -z "$1" ]]
then
    echo $OLD_LIST
    ls $HOME/org/todo-lists/
elif [[ -d "$HOME/org/todo-lists/$1" ]]
then
    rm $HOME/org/todo
    ln -sf todo-lists/$1 $HOME/org/todo
    touch $HOME/org/todo-lists/$OLD_LIST/todo.txt
else
    echo "No such TO-DO list '$1'."
fi

