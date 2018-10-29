#!/bin/bash

cd `dirname $0`
CONF_DIR=$(pwd)

install_links() {
    ln -sf $CONF_DIR/.aliases $HOME/
    ln -sf $CONF_DIR/.bash_logout $HOME/
    ln -sf $CONF_DIR/.bash_profile $HOME/
    ln -sf $CONF_DIR/.bashrc $HOME/
    ln -sf $CONF_DIR/.inputrc $HOME/
    ln -sf $CONF_DIR/.gitconfig $HOME/
    ln -sf $CONF_DIR/.gitignore_global $HOME/
    ln -sf $CONF_DIR/.screenrc $HOME/
    ln -sf $CONF_DIR/.tmux.conf $HOME/
    
    mkdir -p $HOME/.ssh/
    chmod 700 $HOME/.ssh/
    cp $CONF_DIR/.ssh/config $HOME/.ssh/
    chmod 644 $HOME/.ssh/config
    # ln -sf $CONF_DIR/.ssh/config $HOME/.ssh/

    mkdir -p $HOME/.when/
    ln -sf $CONF_DIR/.when/preferences $HOME/.when/
    mkdir -p $HOME/.todo/
    ln -sf $CONF_DIR/.todo/config $HOME/.todo/
    mkdir -p $HOME/Org/
    touch $HOME/Org/calendar
    
    mkdir -p $HOME/.config/
    ln -sf $CONF_DIR/.config/ranger $HOME/.config/
    ln -sf $CONF_DIR/.config/neofetch $HOME/.config/

    mkdir -p $HOME/bin/
    # chmod +x $CONF_DIR/scripts/*
    ln -sf $CONF_DIR/scripts/* $HOME/bin/
}

# Make links in our home directory
echo Creating symbolic links in the home directory
install_links

# Make links in root home directory
# echo Now creating symbolic links in the /root directory
# read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
# INSTALL_LINKS_FUNC=$(declare -f install_links)
# sudo bash -c "CONF_DIR=$CONF_DIR;$INSTALL_LINKS_FUNC; install_links"

