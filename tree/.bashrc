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

# source git-prompt.sh
. /usr/share/git/completion/git-prompt.sh

# prompt
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command()
{
    local EXIT="$?"             # This needs to be first

    local OtherColor=$RS$HC$FWHT

    local DashCh=$(echo $'\u2500')

    local TerminalWidth=$(tput cols)

    ### Prompt line 1 ###

    local TimeColor=$RS$HC$FWHT
    local TimeInfo="[${TimeColor}\D{%T}${OtherColor}]"
    local TimeInfoLength=10

    local ExitCodeColor=$RS$(if [[ $EXIT -ne 0 ]]; then echo $HC$FRED; else echo $FGRN; fi)
    local LastCommandStatus="[${ExitCodeColor}$(if [[ $EXIT -ne 0 ]]; then echo "error $EXIT"; else echo "ok"; fi)${OtherColor}]"
    local LastCommandStatusLength=$((2+$(if [[ $EXIT -ne 0 ]]; then echo $((6+${#EXIT})); else echo 2; fi)))

    local RightArrowCh=$(echo $'\u2192')
    local ProcessSeqStrMaxLength=$((${TerminalWidth}-8-${TimeInfoLength}-${LastCommandStatusLength}))
    local ProcessSeqStr="$(sed "
s/systemd//;
s/---login//;
s/---pstree//;
s/---sh//g;
s/---bash//g;
s/^---//;
s/sshd---sshd/ssh/;
s/tmux: server/tmux/;
s/screen---screen/screen/;
s/y-desktop.sh---screen---yaft/yaft/;
s/---/ ${RightArrowCh} /g; 
" <<< $(pstree -ls $$))"

    local ProcessSeqNameColor=$RS$HC$FWHT
    local ProcessSeqArrowColor=$RS$HC$FYEL
    local ProcessSeqParensColor=$RS$HC$FYEL
    local ProcessSeqGapColor=$RS$HC$FRED

    if [[ -n ${ProcessSeqStr} ]]
    then
        if [[ ${#ProcessSeqStr} -le ${ProcessSeqStrMaxLength} ]]
        then
            local ProcessSeqIndicator="${ProcessSeqParensColor}[ ${ProcessSeqNameColor}${ProcessSeqStr//${RightArrowCh}/\
${ProcessSeqArrowColor}${RightArrowCh}${ProcessSeqNameColor}}${ProcessSeqParensColor} ]"
        else
            local ProcessSeqStrExcessLength=$((${#ProcessSeqStr}-${ProcessSeqStrMaxLength}+3))
            local ProcessSeqStr2=${ProcessSeqStr:${ProcessSeqStrExcessLength}}
            local ProcessSeqIndicator="${ProcessSeqParensColor}[ ${ProcessSeqGapColor}...${ProcessSeqNameColor}${ProcessSeqStr2//${RightArrowCh}/\
${ProcessSeqArrowColor}${RightArrowCh}${ProcessSeqNameColor}}${ProcessSeqParensColor} ]"
        fi
    fi


    local LTCornerCh=$(echo $'\u250C')
    local PromptLine1="${OtherColor}${LTCornerCh}${DashCh}${TimeInfo}${DashCh}${LastCommandStatus} ${ProcessSeqIndicator}"

    ### Prompt line 2 ###

    local UsernameColor=$RS$(if [[ $EUID == 0 ]]; then echo $HC$FRED; else echo $FGRN; fi)
    local HostnameColor=$RS$HC$FBLE
    local UserHostInfo="[${UsernameColor}${USER}${OtherColor}@${HostnameColor}${HOSTNAME}${OtherColor}]"
    local UserHostInfoLength=$((3+${#USER}+${#HOSTNAME}))

    local GitBranchColor=$RS$(if [[ -n "$(git status --short 2> /dev/null)" ]]; then echo $HC$FRED; else echo $FGRN; fi)
    local GitBranch="$(__git_ps1 '%s')"
    local GitRepoInfo="[$(if [[ -n "${GitBranch}" ]]; then echo "${GitBranchColor}${GitBranch}"; fi)${OtherColor}]"
    local GitRepoInfoLength=$((2+${#GitBranch}))

    local PWDInfoMaxLength=$((${TerminalWidth}-6-${UserHostInfoLength}-${GitRepoInfoLength}))
    local PWDColor=$RS$FCYN
    local PWDSlashColor=${OtherColor}
    local PWDGapColor=$RS$HC$FRED
    if [[ ${#PWD} -le ${PWDInfoMaxLength} ]]
    then
        local PWDInfo="[${PWDColor}${PWD//\//${PWDSlashColor}\/${PWDColor}}${OtherColor}]";
    else
        local PWDExcessLength=$((${#PWD}-${PWDInfoMaxLength}+3))
        local PWD1=${PWD:0:${#PWD}/2-(${PWDExcessLength}+1)/2}
        local PWD2=${PWD:${#PWD}/2+${PWDExcessLength}/2}

        local PWDInfo="[${PWDColor}${PWD1//\//${PWDSlashColor}\/${PWDColor}}${PWDGapColor}...${PWDColor}${PWD2//\//${PWDSlashColor}\/${PWDColor}}${OtherColor}]";
    fi

    local LMiddleCh=$(echo $'\u255E')
    local DoubleDashCh=$(echo $'\u2550')
    local PromptLine2="${OtherColor}${LMiddleCh}${DoubleDashCh}${UserHostInfo}${DoubleDashCh}${GitRepoInfo}${DoubleDashCh}${PWDInfo}"

    ### Prompt line 3 ###

    local PromptCharacter=$(if [[ $EUID == 0 ]]; then echo '#'; else echo '$'; fi)

    local LBCornerCh=$(echo $'\u2514')
    local InputModeGap="\[\e[3C\]"
    local PromptLine3="${OtherColor}${LBCornerCh}${DashCh}${InputModeGap}${DashCh}"

    PS1="$RS
${PromptLine1}
${PromptLine2}
${PromptLine3} ${PromptCharacter} $RS"

    PS2="${PromptLine3} > $RS"
}

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

