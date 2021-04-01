#!/bin/sh

curl ifconfig.me 2> /dev/null | grep "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$"

