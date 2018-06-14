#!/bin/bash

cd `dirname $0`
CONF_DIR=$(pwd)

make_links() {
    ln -sf $CONF_DIR/.aliases $1/
    ln -sf $CONF_DIR/.bash_logout $1/
    ln -sf $CONF_DIR/.bash_profile $1/
    ln -sf $CONF_DIR/.bashrc $1/
    ln -sf $CONF_DIR/.inputrc $1/
    ln -sf $CONF_DIR/.gitconfig $1/
    ln -sf $CONF_DIR/.gitignore_global $1/
    
    mkdir -p $1/.ssh/
    ln -sf $CONF_DIR/.ssh/config $1/.ssh/
    
    mkdir -p $1/.config/
    ln -sf $CONF_DIR/.config/ranger $1/.config/
    ln -sf $CONF_DIR/.config/neofetch $1/.config/
}

# Make links in our home directory
make_links ~

# Make links in root home directory
MAKE_LINKS_FUNC=$(declare -f make_links)
sudo bash -c "CONF_DIR=$CONF_DIR;$MAKE_LINKS_FUNC; make_links /root"

