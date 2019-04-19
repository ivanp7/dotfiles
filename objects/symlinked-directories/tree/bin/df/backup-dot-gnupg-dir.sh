#!/bin/sh

tar -cvf $HOME/.gnupg.tar --exclude="*.conf" $HOME/.gnupg > /dev/null 2>&1
gpg --symmetric $HOME/.gnupg.tar
rm $HOME/.gnupg.tar

