HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=10000
setopt appendhistory extendedglob nomatch
unsetopt autocd beep notify

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
fpath=($fpath $HOME/.zsh/completion) 

zmodload zsh/complist
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

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

# keys
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

# syntax highlighting
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# "command not found"
. /usr/share/doc/pkgfile/command-not-found.zsh

# disable ctrl+s/ctrl+q
stty -ixon -ixoff

# man
man () 
{
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;33m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[7m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    man -P "less -Q" "$@"
}

# lf
lfcd () 
{
    tmp="$(mktemp)"
    fid="$(mktemp)"
    lf -command '$printf $id > '"$fid"'' -last-dir-path="$tmp" "$@"
    id="$(cat "$fid")"
    archivemount_dir="/tmp/__lf_archivemount_$id"
    if [ -f "$archivemount_dir" ]; then
        cat "$archivemount_dir" | \
            while read -r line; do
                umount "$line"
                rmdir "$line"
            done
        rm -f "$archivemount_dir"
    fi
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}


tx ()
{
    if [[ -o interactive ]] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
    then tmux attach || . $HOME/.scripts/df/tmux-default-session.sh; fi
}

# color grid
colorgrid ()
{
    local iter=0
    while [ $iter -lt 16 ]
    do
        echo -en "\033[38;5;$(echo $iter)m█ "
        printf "%03d" $iter

        if [ $(($iter % 8)) = 7 ]
        then printf '\r\n'; else printf ' '; fi

        local iter=$(($iter+1))
    done

    printf '\r\n'

    local iter=16
    while [ $iter -lt 52 ]
    do
        local second=$(($iter+36))
        local third=$(($second+36))
        local four=$(($third+36))
        local five=$(($four+36))
        local six=$(($five+36))
        local seven=$(($six+36))

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
        if [ $seven -lt 256 ]; then
            echo -en "   \033[38;5;$(echo $seven)m█ "
            printf "%03d" $seven
        fi

        local iter=$(($iter+1))
        printf '\r\n'
    done
}

# aliases
alias sudo='sudo '
. $HOME/.aliases
{ command -v xhost > /dev/null && xhost > /dev/null 2>&1 &&
    [ -f $HOME/.xaliases ] && . $HOME/.xaliases; } || true

# element of yaft drawing bug workaround
. $HOME/.scripts/df/yaft-workaround.sh

# unfreeze terminal if left frozen
ttyctl -f

# shell prompt
. $HOME/.zshrc.prompt

# vim: set ft=zsh:

