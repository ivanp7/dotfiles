#!/bin/bash

cd `dirname $0`
CONF_DIR=$PWD

install_tree()
{
    cp -asfT $CONF_DIR/tree $HOME
}

install_special_org()
{
    mkdir -p $HOME/Org/todo
    touch $HOME/Org/calendar
    touch $HOME/Org/todo/todo.txt

    local DOTFILES_CALENDAR_JOB="00 00 * * * /usr/bin/echo -n '' >> $HOME/Org/calendar"
    if ! crontab -l | fgrep "$DOTFILES_CALENDAR_JOB" &> /dev/null
    then (crontab -l 2> /dev/null; echo "$DOTFILES_CALENDAR_JOB") | crontab -; fi
}

install_special_git()
{
    cp -f $CONF_DIR/special/git/.gitconfig $HOME/
    chmod 644 $HOME/.gitconfig
    sed -i "s/USERNAME/$(whoami)/g" $HOME/.gitconfig
}

install_special_ssh()
{
    mkdir -p $HOME/.ssh/
    chmod 700 $HOME/.ssh/
    cp -f $CONF_DIR/special/ssh/config $HOME/.ssh/
    chmod 644 $HOME/.ssh/config
}

install_special_tmux()
{
    if [ ! -d $CONF_DIR/special/tmux/plugins/tpm ]
    then git clone https://github.com/tmux-plugins/tpm $CONF_DIR/special/tmux/plugins/tpm
    fi

    mkdir -p $HOME/.tmux/
    ln -sf $CONF_DIR/special/tmux/plugins $HOME/.tmux/
}

install_special_systemd()
{
    if [[ $EUID -ne 0 ]]
    then
        mkdir -p $HOME/.config/systemd/user/
        ln -sf $CONF_DIR/special/systemd/* $HOME/.config/systemd/user/

        for serv in $(find $CONF_DIR/special/systemd/ -type f)
        do
            systemctl --user enable $(basename $serv)
        done
    else
        ln -sf $CONF_DIR/special/systemd/* /etc/systemd/system/

        for serv in $(find $CONF_DIR/special/systemd/ -type f)
        do
            systemctl enable $(basename $serv)
        done
    fi
}

echo Installing configuration...
install_tree
install_special_org
install_special_git
install_special_ssh
install_special_tmux
install_special_systemd
echo Done!

