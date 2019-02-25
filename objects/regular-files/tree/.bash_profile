#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

powerline-daemon -q
eval "$(ssh-agent)" > /dev/null
eval "$(gpg-agent --daemon)" > /dev/null

clear

$HOME/bin/print-motd.sh

