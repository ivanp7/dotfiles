[ -z "$SSH_AUTH_SOCK" ] && eval $(ssh-agent -s) > /dev/null 

if [ -n "$SSH_AUTH_SOCK" ] 
then
    _SSH_ADD_HOST=$(hostname)
    _SSH_ADD_PASSPHRASE_COMP="computers/$_SSH_ADD_HOST/os/linux/$USER/ssh/passphrase"
    _SSH_ADD_PASSPHRASE_VM="vm/$_SSH_ADD_HOST/os/linux/$USER/ssh/passphrase"
    unset _SSH_ADD_HOST

    if [ -n "${_SSH_ADD_PASSPHRASE:=$(pass "$_SSH_ADD_PASSPHRASE_COMP" 2> /dev/null)}" -o \
         -n "${_SSH_ADD_PASSPHRASE:=$(pass "$_SSH_ADD_PASSPHRASE_VM" 2> /dev/null)}" ]
    then 
        $HOME/.scripts/df/ssh-add.expect "$USER" "$_SSH_ADD_PASSPHRASE"
    else 
        ssh-add
    fi

    unset _SSH_ADD_PASSPHRASE _SSH_ADD_PASSPHRASE_COMP _SSH_ADD_PASSPHRASE_VM
fi

