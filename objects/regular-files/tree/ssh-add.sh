#!/usr/bin/expect -f

set username [lindex $argv 0]
set password [lindex $argv 1]

spawn ssh-add
expect "Enter passphrase for /home/$username/.ssh/id_rsa: "
send "$password\n";
expect "Identity added: /home/$username/.ssh/id_rsa (/home/$username/.ssh/id_rsa)"
interact

