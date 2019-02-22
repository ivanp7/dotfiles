#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

powerline-daemon -q
eval $(ssh-agent) > /dev/null

clear

$HOME/bin/print-motd.sh

