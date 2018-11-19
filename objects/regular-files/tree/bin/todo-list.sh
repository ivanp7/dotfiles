#!/bin/bash

OLD_LIST=$(basename $(readlink $HOME/Org/todo))

if [[ -z "$1" ]]
then
    echo $OLD_LIST
else
    rm $HOME/Org/todo
    ln -sf $HOME/Org/todo-lists/$1 $HOME/Org/todo
    touch $HOME/Org/todo-lists/$OLD_LIST/todo.txt
fi

