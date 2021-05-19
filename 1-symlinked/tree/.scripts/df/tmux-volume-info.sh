#!/bin/sh

echo -n " "
volume.sh | grep "<<<<<<" | sed "s/ <<<<<<//"

