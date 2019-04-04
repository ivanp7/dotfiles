#!/bin/bash

# check if any profile is up
for p in $(netctl list)
do 
    profile=$(echo $p | tr -d "*+ ")
    if netctl status $profile > /dev/null; then echo "Profile $profile is already up"; exit 1; fi
done

# start one of profiles
for p in $(netctl list)
do 
    profile=$(echo $p | tr -d "*+ ")
    if sudo netctl start $profile > /dev/null; then echo "Started profile $profile"; exit 0; fi
done

exit 1

