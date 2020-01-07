if [ -z "$SSH_AUTH_SOCK" ] 
then
    eval `ssh-agent -s` > /dev/null
    
    _PASSPHRASE_COMP="computers/$HOST/os/archlinux/$USER/ssh/passphrase"
    _PASSPHRASE_VM="vm/$HOST/os/archlinux/$USER/ssh/passphrase"

    if [ -f "$HOME/.password-store/$_PASSPHRASE_COMP.gpg" ]
    then 
        _PASSPHRASE="$_PASSPHRASE_COMP"
        unset _PASSPHRASE_COMP
    elif [ -f "$HOME/.password-store/$_PASSPHRASE_VM.gpg" ]
    then 
        _PASSPHRASE="$_PASSPHRASE_VM"
        unset _PASSPHRASE_VM
    fi

    if [ -n "$_PASSPHRASE" ]
    then 
        $HOME/.scripts/df/ssh-add.expect "$USER" "$(pass $_PASSPHRASE)"
        unset _PASSPHRASE
    else ssh-add
    fi
fi

