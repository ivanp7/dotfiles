#!/bin/sh

UNINST_SCRIPT=$1

JOB="0 0 * * * /usr/bin/touch $HOME/.when/calendar"

crontab -l | { cat; echo "$JOB"; } | crontab -

[ -n "$UNINST_SCRIPT" ] &&
echo "
crontab -l | sed '/$(echo "$JOB" | sed 's@\*@\\*@g; s@\.@\\.@g; s@/@\\/@g')/d' | crontab -
" >> $UNINST_SCRIPT

