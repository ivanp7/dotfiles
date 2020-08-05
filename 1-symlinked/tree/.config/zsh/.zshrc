# Options & initialization {{{

# zsh directories
mkdir -p $XDG_CACHE_HOME/zsh
mkdir -p $XDG_DATA_HOME/zsh

# options
HISTFILE=$XDG_DATA_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=10000
setopt appendhistory extendedglob nomatch
setopt autocd autopushd pushdignoredups
unsetopt beep notify

setopt COMPLETE_ALIASES
setopt HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

autoload -Uz add-zsh-hook

# help
autoload -Uz run-help
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-sudo
alias help=run-help

# completion
fpath=($fpath $ZDOTDIR/completion) 

autoload -Uz compinit
zmodload zsh/complist
zstyle :compinstall filename $ZDOTDIR/.zshrc
zstyle ':completion:*' menu select
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots) # Include hidden files

# auto prehash
zshcache_time="$(date +%s%N)"
rehash_precmd () 
{
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd

# syntax highlighting
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# "command not found"
. /usr/share/doc/pkgfile/command-not-found.zsh

# disable ctrl+s/ctrl+q
stty -ixon -ixoff

# }}}
# Keys {{{

bindkey -v

autoload edit-command-line
zle -N edit-command-line

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[ -n "${key[Insert]}"    ] && bindkey -- "${key[Insert]}"    overwrite-mode
[ -n "${key[Backspace]}" ] && bindkey -- "${key[Backspace]}" vi-backward-delete-char
[ -n "${key[Delete]}"    ] && bindkey -- "${key[Delete]}"    vi-delete-char
[ -n "${key[PageUp]}"    ] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[ -n "${key[PageDown]}"  ] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[ -n "${key[ShiftTab]}"  ] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[[D' vi-backward-char
bindkey '^[[C' vi-forward-char 
bindkey '^[[H' vi-beginning-of-line
bindkey '^[[F' vi-end-of-line
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey '^v' edit-command-line
bindkey -M vicmd '^v' edit-command-line

bindkey '\C-b' vi-backward-char
bindkey '\C-f' vi-forward-char
bindkey '\C-a' vi-beginning-of-line
bindkey '\C-e' vi-end-of-line

fzf_cd ()
{
    dir="$(find -L . -mindepth 1 -maxdepth 10 -type d -printf '%P\n' 2> /dev/null | fzf --header='Change directory')"
    [ -z "$dir" ] && return
    cd "$dir"
    zle push-line
    zle accept-line
}
zle -N fzf_cd

bindkey '\C-t' fzf_cd

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
    autoload -Uz add-zle-hook-widget
    function zle_application_mode_start {
        echoti smkx
    }
    function zle_application_mode_stop {
        echoti rmkx
    }
    add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
    add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# }}}
# Extra configuration {{{

# functions
. $ZDOTDIR/functions

# aliases
alias sudo='sudo '
. $ZDOTDIR/aliases
{ command -v xhost > /dev/null && xhost > /dev/null 2>&1 &&
    [ -f $ZDOTDIR/xaliases ] && . $ZDOTDIR/xaliases; } || true

# extra configuration
[ -f "$ZDOTDIR/config" ] && . $ZDOTDIR/config

# }}}
# Prompt {{{

# unfreeze terminal if left frozen
ttyctl -f

# shell prompt
. $ZDOTDIR/prompt

# }}}

# vim: ft=zsh: foldmethod=marker:
