#!/bin/bash

CONF_DIR=$(pwd)

ln -sf $CONF_DIR/.aliases ~/
ln -sf $CONF_DIR/.bash_logout ~/
ln -sf $CONF_DIR/.bash_profile ~/
ln -sf $CONF_DIR/.bashrc ~/
ln -sf $CONF_DIR/.inputrc ~/
ln -sf $CONF_DIR/.gitconfig ~/
ln -sf $CONF_DIR/.gitignore_global ~/

mkdir -p ~/.ssh/
ln -sf $CONF_DIR/.ssh/config ~/.ssh/

mkdir -p ~/.config/
ln -sf $CONF_DIR/.config/ranger ~/.config/
ln -sf $CONF_DIR/.config/neofetch ~/.config/

sudo ln -sf $CONF_DIR/.aliases /root/
sudo ln -sf $CONF_DIR/.bash_logout /root/
sudo ln -sf $CONF_DIR/.bash_profile /root/
sudo ln -sf $CONF_DIR/.bashrc /root/
sudo ln -sf $CONF_DIR/.inputrc /root/
sudo ln -sf $CONF_DIR/.gitconfig /root/
sudo ln -sf $CONF_DIR/.gitignore_global /root/

sudo mkdir -p /root/.ssh/
sudo ln -sf $CONF_DIR/.ssh/config /root/.ssh/

sudo mkdir -p /root/.config/
sudo ln -sf $CONF_DIR/.config/ranger /root/.config/
sudo ln -sf $CONF_DIR/.config/neofetch /root/.config/
