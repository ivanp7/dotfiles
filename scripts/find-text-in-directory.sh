#!/bin/bash

find $1 -xdev -type f -print0 | xargs -0 grep -H $2

