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

# aliases
. ${HOME}/.aliases
{ type xhost >& /dev/null && xhost >& /dev/null &&
    [ -f ${HOME}/.xaliases ] && . ${HOME}/.xaliases; } || true

# element of yaft drawing bug workaround
if [[ "$TERM" == "yaft-256color" ]]
then
    if [ -f $HOME/.tmux_tmp/tmp ]
    then
        echo $(tty) > $HOME/.tmux_tmp/$(cat $HOME/.tmux_tmp/tmp)
        rm $HOME/.tmux_tmp/tmp
    fi

    . $HOME/tmux.sh
fi

# run tmux in nonlogin shell
# shopt -q login_shell || . $HOME/tmux.sh

