#!/bin/sh

tar -cvf .gnupg.tar --exclude="*.conf" -C $HOME/.gnupg . > /dev/null 2>&1
gpg --symmetric .gnupg.tar
rm .gnupg.tar

