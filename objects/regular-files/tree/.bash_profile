#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# echo
# echo
clear

echo
neofetch
echo
echo

powerline-daemon -q
eval $(ssh-agent) > /dev/null

