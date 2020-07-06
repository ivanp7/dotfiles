#!/bin/sh

if [ -z "$SSH_AUTH_SOCK" ] 
then
    eval $(ssh-agent -s) > /dev/null
    
    HOST=$(hostname)
    PASSPHRASE_COMP="computers/$HOST/os/linux/$USER/ssh/passphrase"
    PASSPHRASE_VM="vm/$HOST/os/linux/$USER/ssh/passphrase"

    if [ -n "${PASSPHRASE:=$(pass "$PASSPHRASE_COMP" 2> /dev/null)}" -o \
         -n "${PASSPHRASE:=$(pass "$PASSPHRASE_VM" 2> /dev/null)}" ]
    then 
        $HOME/.scripts/df/ssh-add.expect "$USER" "$PASSPHRASE"
    else 
        ssh-add
    fi
fi

