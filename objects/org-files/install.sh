#!/bin/bash

CONF_DIR=$(realpath `dirname $0`)

mkdir -p $HOME/org/todo-lists/general
touch $HOME/org/todo-lists/general/todo.txt
rm $HOME/org/todo
ln -sf todo-lists/general $HOME/org/todo

touch $HOME/org/calendar

