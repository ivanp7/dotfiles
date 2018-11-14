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

    # Disable&stop services
    for service in $(find $CONF_DIR/special/systemd/ -type f -name "*.service")
    do
        local timer=$(echo $service | sed "s/service$/timer/")

        if [ -f $timer ]
        then
            local target=$timer
        else
            local target=$service
        fi

        systemctl $USER_FLAG stop $(basename $target)
        systemctl $USER_FLAG disable $(basename $target)
    done

    # Update services
    ln -sf $CONF_DIR/special/systemd/* $TARGET_DIR

    # Enable&start services
    for service in $(find $CONF_DIR/special/systemd/ -type f -name "*.service")
    do
        local timer=$(echo $service | sed "s/service$/timer/")

        if [ -f $timer ]
        then
            local target=$timer
        else
            local target=$service
        fi

        systemctl $USER_FLAG enable $(basename $target)
        # systemctl $USER_FLAG start $(basename $target)
    done
}

case $1 in
    tree)
        echo "Installing tree only..."
        install_tree
        echo "Done!"
        ;;

    org)
        echo "Installing org files only..."
        install_special_org
        echo "Done!"
        ;;

    git)
        echo "Installing git config only..."
        install_special_git
        echo "Done!"
        ;;

    ssh)
        echo "Installing ssh config only..."
        install_special_ssh
        echo "Done!"
        ;;

    tmux)
        echo "Installing tmux config only..."
        install_special_tmux
        echo "Done!"
        ;;

    systemd)
        echo "Installing systemd units only..."
        install_special_systemd
        echo "Done!"
        ;;

    "")
        echo "Installing everything..."
        install_tree
        install_special_org
        install_special_git
        install_special_ssh
        install_special_tmux
        install_special_systemd
        echo "Done!"
        ;;

    *)
        echo "Error: invalid argument."
esac

