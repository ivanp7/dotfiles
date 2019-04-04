#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ -z "$SSH_AUTH_SOCK" ] 
then
    eval `ssh-agent -s` > /dev/null
    
    PASSPHRASE=computers/$HOSTNAME/os/archlinux/$USER/ssh/passphrase
    if [ -f "$HOME/.password-store/$PASSPHRASE.gpg" ]
    then $HOME/ssh-add.sh "$USER" "$(pass $PASSPHRASE)"
    else ssh-add
    fi
fi

powerline-daemon -q

sleep 1
clear

$HOME/bin/print-motd.sh

