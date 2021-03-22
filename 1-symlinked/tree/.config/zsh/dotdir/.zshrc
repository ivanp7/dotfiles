# Variables {{{

PARENT_SHELL_PID=$PARENT_SHELL_PID_EXPORTED
export PARENT_SHELL_PID_EXPORTED=$$

_pstree="$(exec pstree -ls $$)"
_pstree="$(echo "$_pstree" | head -1 | sed -Ef "$HOME/.scripts/df/pstree.sed")"

_colors=$(tput colors)

_color_reset="\033[0m"
_color_underline="\033[4m"
_color_no_underline="\033[24m"
_color_strike="\033[9m"
_color_no_strike="\033[29m"
_color_blink="\033[5m"
_color_no_blink="\033[25m"

# }}}
# Functions {{{

. "$ZDOTDIR/functions"

# }}}
# Aliases {{{

alias sudo='sudo '

alias sudoenv="sudo --preserve-env=$SUDO_PRESERVE_ENV "
alias sush='sudo_shell '

alias si='shell_info'
alias sep='separator'
alias spe='spectrum'

alias ls='ls --group-directories-first --color=auto'
alias ll='ls --group-directories-first -alF'
alias la='ls --group-directories-first -A'
alias l='ls --group-directories-first -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias diff='diff --color=auto'

alias less="$PAGER"

alias nv='nvim'

alias lf='lfcd'
alias d='dirs -v | head'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias ssh_='TERM=xterm-256color ssh '

alias pwd_='printf "%q\n" "$(pwd)"'

# }}}
# Extra configuration {{{

_ZSH_RC_DIR="$(realpath -L "$ZDOTDIR/../rc")"
if [ -d "$_ZSH_RC_DIR" ]
then
    for file in $(find "$_ZSH_RC_DIR/" -type f,l)
    do . "$file"
    done
fi
unset _ZSH_RC_DIR

# }}}
# Configuration of interactive session {{{

[ -z "$NON_INTERACTIVE" ] && . "$ZDOTDIR/interactive" || true

# }}}

# vim: ft=zsh: foldmethod=marker:
