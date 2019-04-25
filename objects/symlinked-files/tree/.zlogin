if [ -z "$SSH_AUTH_SOCK" ] 
then
    eval `ssh-agent -s` > /dev/null
    
    _PASSPHRASE=computers/$HOST/os/archlinux/$USER/ssh/passphrase
    if [ -f "$HOME/.password-store/$_PASSPHRASE.gpg" ]
    then $HOME/scripts/df/ssh-add.expect "$USER" "$(pass $_PASSPHRASE)"
    else ssh-add; fi
    unset _PASSPHRASE
fi

powerline-daemon -q

sleep 1
clear

$HOME/bin/df/print-motd.sh

