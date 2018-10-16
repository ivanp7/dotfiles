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

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

# prompt
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command()
{
    local EXIT="$?"             # This needs to be first

    local UsernameColor=$RS$(if [[ $EUID == 0 ]]; then echo $HC$FRED; else echo $FGRN; fi)
    local HostnameColor=$RS$HC$FBLE
    local PWDColor=$RS$HC$FYEL
    local TimeColor=$RS$FCYN
    local RangerColor=$RS$FWHT
    local VimColor=$RS$FWHT
    local ReturnStatusColor=$RS$HC$FRED
    local OtherColor=$RS$HC$FWHT

    local RangerIndicator=$(if [[ ! -z $RANGER_LEVEL ]]; then 
        echo "<${RangerColor}ranger$(if [[ $RANGER_LEVEL -gt 1 ]]; then echo -n "-$RANGER_LEVEL"; fi)$OtherColor> "; fi)
    local VimIndicator=$(if [[ ! -z $VIM ]]; then 
        echo "<${VimColor}vim$OtherColor> "; fi)
    local LastCommandStatus=$(if [[ $EXIT -ne 0 ]]; then echo ": ${RS}code $ReturnStatusColor$EXIT$RS"; fi)
    local PromptPrefix1=$'\u2514\u2500'
    local PromptPrefix2=$'\u2500'
    local PromptCharacter=$(if [[ $EUID == 0 ]]; then echo \#; else echo \$; fi)

    PS1="$OtherColor\n$(echo $'\u250C\u2500')[$UsernameColor\u$OtherColor@$HostnameColor\h$OtherColor]\
$(echo $'\u2500')[$PWDColor\w$OtherColor] $TimeColor\D{%T}${OtherColor} $RangerIndicator$VimIndicator$LastCommandStatus\n\
$OtherColor$PromptPrefix1\[\e[3C\]$PromptPrefix2 $PromptCharacter $RS"

    PS2="$OtherColor$PromptPrefix > $RS"
}

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# other settings
source /usr/share/doc/pkgfile/command-not-found.bash

stty -ixon

# variables
if [[ ! -v PATH_SET ]]
then
    export PATH="${PATH}:${HOME}/scripts:${HOME}/bin"
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
function ranger ()
{
    local SHELL=$HOME/bin/r.shell

    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}

function sudo_ranger ()
{
    local SHELL=$HOME/bin/r.shell

    if [ -z "$RANGER_LEVEL" ] || [ $EUID -ne 0 ]; then
        sudo -E /usr/bin/ranger "$@"
    else
        exit
    fi
}

# aliases
source ${HOME}/.aliases
{ type xhost >& /dev/null && xhost >& /dev/null &&
    [ -f ${HOME}/.xaliases ] && source ${HOME}/.xaliases; } || true

