#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# history
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

shopt -s checkwinsize
shopt -s globstar
shopt -s autocd

# bash prompt
. $HOME/.bash_prompt

# Use bash-completion, if available
[[ -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# other settings
. /usr/share/doc/pkgfile/command-not-found.bash

stty -ixon

# variables
if [[ ! -v PATH_SET ]]
then
    export PATH="${PATH}:${HOME}/bin/scripts:${HOME}/bin"
    export PATH_SET=true
fi

export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;33m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[7m'        # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export EDITOR='/usr/bin/vim'

# custom apps
complete -F _todo todo

# functions
function __rngr_test ()
{
    test -f "$1" &&
        if [ "$(cat -- "$1")" != "$(echo -n `pwd`)" ]; then
            cd -- "$(cat "$1")"
        fi
        rm -f -- "$1"
}

function ranger ()
{
    tempfile="$(mktemp -t tmp.XXXXXX)"
    SHELL=$HOME/r.shell /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    __rngr_test "$tempfile"
}

function sudo_ranger ()
{
    tempfile="$(mktemp -t tmp.XXXXXX)"
    sudo SHELL=$HOME/r.shell /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    __rngr_test "$tempfile"
}

# color grid
function colorgrid ()
{
    local iter=16
    while [ $iter -lt 52 ]
    do
        local second=$[$iter+36]
        local third=$[$second+36]
        local four=$[$third+36]
        local five=$[$four+36]
        local six=$[$five+36]
        local seven=$[$six+36]
        if [ $seven -gt 250 ]; then seven=$[$seven-251]; fi

        echo -en "\033[38;5;$(echo $iter)m█ "
        printf "%03d" $iter
        echo -en "   \033[38;5;$(echo $second)m█ "
        printf "%03d" $second
        echo -en "   \033[38;5;$(echo $third)m█ "
        printf "%03d" $third
        echo -en "   \033[38;5;$(echo $four)m█ "
        printf "%03d" $four
        echo -en "   \033[38;5;$(echo $five)m█ "
        printf "%03d" $five
        echo -en "   \033[38;5;$(echo $six)m█ "
        printf "%03d" $six
        echo -en "   \033[38;5;$(echo $seven)m█ "
        printf "%03d" $seven

        local iter=$[$iter+1]
        printf '\r\n'
    done
}

# aliases
alias sudo='sudo '
. ${HOME}/.aliases
{ type xhost >& /dev/null && xhost >& /dev/null &&
    [ -f ${HOME}/.xaliases ] && . ${HOME}/.xaliases; } || true

# element of yaft drawing bug workaround
if [[ "$TERM" == "yaft-256color" ]]
then
    if [ -f /tmp/tmux-refresh-service-$(whoami)/tmp ]
    then
        echo $(tty) > /tmp/tmux-refresh-service-$(whoami)/$(cat /tmp/tmux-refresh-service-$(whoami)/tmp)
        rm /tmp/tmux-refresh-service-$(whoami)/tmp
    fi

    . $HOME/tmux.sh
fi

# run tmux in nonlogin shell
# shopt -q login_shell || . $HOME/tmux.sh

