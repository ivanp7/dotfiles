# prompt

# source git-prompt.sh
. /usr/share/git/completion/git-prompt.sh

############################################################################

_p_bold="%B"
_p_stopbold="%b"
_p_underline="%U"
_p_stopunderline="%u"

_p_color()
{
    echo "%F{$1}$([ -n "$2" ] && echo "%K{$2}" || true)"
}

_p_safe_color()
{
    if [ $(tput colors) -gt 8 ]; then echo "$1"; else echo "$2"; fi
}

_p_color_white=${_p_bold}$(_p_color 7)

_p_stdcolor=$(_p_safe_color "$(_p_color 244)" "$(_p_color 7)${_p_stopbold}")%k
_p_cmdcolor=${_p_color_white}

_p_dash="─"
_p_2dash="═"
_p_arrow="→"
_p_top="┌"
_p_mid="╞"
_p_bot="└"

############################################################################

_p_timeinfo()
{
    local TimeInfoColor=${_p_color_white}
    echo "${_p_dash}[${TimeInfoColor}%D{%T}${_p_stdcolor}]"
}

_p_cmdtimeinfo()
{
    local CmdTimeInfoColor=${_p_color_white}
    echo "${_p_dash}[${CmdTimeInfoColor}${_p_timer_delta}s${_p_stdcolor}]"
}

_p_cmdstatusinfo()
{
    SuccessColor=${_p_bold}$(_p_color 2)
    FailureColor=${_p_bold}$(_p_color 1)
    if [ $_p_exitcode -eq 0 ]
    then
        echo "${_p_dash}[${SuccessColor}ok${_p_stdcolor}]"
    else
        echo "${_p_dash}[${FailureColor}error ${_p_exitcode}${_p_stdcolor}]"
    fi
}

_p_processinfo()
{
    local OutputStr="$(sed "
        s/systemd//;
        s/---login//;
        s/---pstree//;
        s/---sh//g;
        s/---dash//g;
        s/---bash//g;
        s/---zsh//g;
        s/^---//;
        s/sshd---sshd/ssh/;
        s/tmux: server/tmux/;
        s/screen---screen/screen/;
        s/y-desktop.sh---screen---yaft/yaft/;
        s/---/]${_p_arrow}[/g; 
    " <<< $(pstree -ls $$))"

    [ -z $OutputStr ] && exit

    local TimeInfoLength=11
    local CmdTimeInfoLength=$((4 + ${#_p_timer_delta}))
    local CmdStatusLength=$((3 + $(
        if [ $_p_exitcode -ne 0 ]
        then echo $((6 + ${#_p_exitcode}))
        else echo 2
        fi)
    ))

    local PromptLength=$((2 + $TimeInfoLength + $CmdTimeInfoLength + $CmdStatusLength + 2))
    local MaxOutputLength=$(($_p_termwidth - $PromptLength))

    local PNameColor=${_p_color_white}
    local GapColor=$(_p_color 1)

    local SeparatorL="]${_p_arrow}"
    local ColSeparatorL="${_p_stdcolor}]${_p_arrow}"
    local SeparatorR="${_p_arrow}["
    local ColSeparatorR="${_p_arrow}[$PNameColor"

    if [ ${#OutputStr} -le $MaxOutputLength ]
    then
        local HalfColoredOutputStr=${OutputStr//$SeparatorL/$ColSeparatorL}
        local ColoredOutputStr=${HalfColoredOutputStr//$SeparatorR/$ColSeparatorR}
        echo "[$PNameColor$ColoredOutputStr${_p_stdcolor}]"
    else
        local OutputStrExcessLength=$((3 + ${#OutputStr} - $MaxOutputLength - 1))
        local OutputStrShort=${OutputStr:$OutputStrExcessLength}
        local HalfColoredOutputStrShort=${OutputStrShort//$SeparatorL/$ColSeparatorL}
        local ColoredOutputStrShort=${HalfColoredOutputStrShort//$SeparatorR/$ColSeparatorR}
        echo "$GapColor...${_p_stdcolor}$ColoredOutputStrShort${_p_stdcolor}]"
    fi
}

############################################################################

_p_username()
{
    if [ "$USER" = "ivanp7" ] && [ $(tput colors) -ge 256 ]
    then
        local colorI=$(_p_color 196)
        local colorV=$(_p_color 166)
        local colorA=$(_p_color 136)
        local colorN=$(_p_color 106)
        local colorP=$(_p_color  76)
        local color7=$(_p_color  46)
        echo "${colorI}i${colorV}v${colorA}a${colorN}n${colorP}p${color7}7${_p_stdcolor}"
        exit
    fi

    UserColor=$(_p_color 2)
    RootColor=${_p_bold}$(_p_color 7 1)
    if [ "$(id -u)" -ne 0 ]
    then
        echo "${UserColor}$USER${_p_stdcolor}"

    else
        echo "${RootColor}$USER${_p_stdcolor}"
    fi
}

_p_userhostinfo()
{
    HostColor=$(_p_safe_color "$(_p_color 39)" "${_p_bold}$(_p_color 4)")
    echo "${_p_2dash}[$(_p_username)@${HostColor}$HOST${_p_stdcolor}]"
}

_p_gitinfo()
{
    BranchColor=$(_p_safe_color "$(_p_color 165)" "${_p_bold}$(_p_color 5)")
    ChangedBranchColor=$(_p_safe_color "$(_p_color 16 165)" "${_p_bold}$(_p_color 7 5)")
    if [ -z ${_p_gitbranch} ]
    then
        echo "${_p_2dash}[${BranchColor}-${_p_stdcolor}]"

    elif [ -z $_p_gitstatus ]
    then
        echo "${_p_2dash}[${BranchColor}${_p_gitbranch}${_p_stdcolor}]"

    else
        echo "${_p_2dash}[${ChangedBranchColor}${_p_gitbranch}${_p_stdcolor}]"
    fi
}

_p_pwdinfo()
{
    local UserHostInfoLength=$((4 + ${#USER} + ${#HOST}))
    local GitInfoLength=$((3 + $(
        if [ -n ${_p_gitbranch} ]
        then echo ${#_p_gitbranch}
        else echo 1
        fi)
    ))

    local PromptLength=$((1 + $UserHostInfoLength + $GitInfoLength + 3))
    local MaxOutputLength=$(($_p_termwidth - $PromptLength))

    local DirColor=${_p_color_white}${_p_underline}
    local SlashColor=${_p_stdcolor}${_p_stopunderline}
    local GapColor=$(_p_color 1)${_p_stopunderline}

    if [ ${#PWD} -le $MaxOutputLength ]
    then
        local ColPWD=$DirColor${PWD//\//$SlashColor\/$DirColor}
        echo "${_p_2dash}[$ColPWD${_p_stdcolor}${_p_stopunderline}]"
    else
        local PWDExcessLength=$((3 + ${#PWD} - $MaxOutputLength))
        local PWD1=${PWD:0:(${#PWD} - ($PWDExcessLength + 1)) / 2}
        local ColPWD1=$DirColor${PWD1//\//$SlashColor\/$DirColor}
        local PWD2=${PWD:(${#PWD} + $PWDExcessLength) / 2}
        local ColPWD2=$DirColor${PWD2//\//$SlashColor\/$DirColor}

        echo "${_p_2dash}[$ColPWD1$GapColor...$ColPWD2${_p_stdcolor}${_p_stopunderline}]"
    fi
}

############################################################################

_p_vim_mode=

function zle-keymap-select {
    RPS1=
    [ "$KEYMAP" = "vicmd" ] && RPS1="%F{7}%K{1}-- COMMAND --%k%f"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
    RPS1=
    RPS2=
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
function TRAPINT() {
  RPS1=
  RPS2=
  return $(( 128 + $1 ))
} 

_p_character()
{
    if [ "$(id -u)" -ne 0 ]; then echo "$"; else echo "#"; fi
}

############################################################################

_p_timer_start ()
{
    _p_timer=${_p_timer:-$SECONDS}
}

_p_timer_delta=0

_p_command ()
{
    _p_exitcode="$?" # This needs to be first

    if [ -n "$_p_timer" ]
    then
        _p_timer_delta=$(($SECONDS - $_p_timer))
        [ $_p_timer_delta -lt 0 ] && _p_timer_delta=0
        unset _p_timer
    fi

    _p_termwidth=$(tput cols)

    _p_gitbranch="$(__git_ps1 '%s')"
    _p_gitstatus=$([ -n "$(git status --short 2> /dev/null)" ] && echo "changed")

    ### Prompt ###

    local PromptLine1="${_p_stdcolor}${_p_top}$(_p_timeinfo)$(_p_cmdtimeinfo)$(_p_cmdstatusinfo) $(_p_processinfo)"
    local PromptLine2="${_p_stdcolor}${_p_mid}$(_p_userhostinfo)$(_p_gitinfo)$(_p_pwdinfo)"
    local PromptLine3="${_p_stdcolor}${_p_bot}${_p_dash}"

    RPROMPT=""
    RPROMPT2=""

    PS1="${_p_stdcolor}
$PromptLine1
$PromptLine2
$PromptLine3 $(_p_character) ${_p_cmdcolor}"

    PS2="$PromptLine3 > ${_p_cmdcolor}"
}

add-zsh-hook preexec _p_timer_start
add-zsh-hook precmd _p_command

# vim: set ft=sh:

