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
}

install_special_git()
{
    cp -f $CONF_DIR/special/git/.gitconfig $HOME/
    chmod 644 $HOME/.gitconfig
    sed -i "s/USERNAME/$(whoami)/g" $HOME/.gitconfig
    sed -i "s@HOME@$HOME@g" $HOME/.gitconfig
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
    if [ $EUID -ne 0 ]
    then
        mkdir -p $HOME/.config/systemd/user/
        local TARGET_DIR=$HOME/.config/systemd/user/
        local USER_FLAG=--user
    else
        local TARGET_DIR=/etc/systemd/system/
    fi

    ln -sf $CONF_DIR/special/systemd/* $TARGET_DIR

    for service in $(find $CONF_DIR/special/systemd/ -type f -name "*.service")
    do
        local timer=$(echo $service | sed "s/service$/timer/")

        if [ -f $timer ]
        then
            systemctl $USER_FLAG enable $(basename $timer)
            systemctl $USER_FLAG start $(basename $timer)
        else
            systemctl $USER_FLAG enable $(basename $service)
            systemctl $USER_FLAG start $(basename $service)
        fi
    done
}

echo Installing configuration...
install_tree
install_special_org
install_special_git
install_special_ssh
install_special_tmux
install_special_systemd
echo Done!

