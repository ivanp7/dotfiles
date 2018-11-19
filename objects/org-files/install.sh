#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/Org/todo-lists/general
touch $HOME/Org/todo-lists/general/todo.txt
rm $HOME/Org/todo
ln -sf todo-lists/general $HOME/Org/todo

touch $HOME/Org/calendar

