#!/bin/sh

echo "$HOME/.when/calendar" | entr -c sh -c 'cal -3; echo; echo; when --noheader'

