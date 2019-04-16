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
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

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
autoload edit-command-line
zle -N edit-command-line

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -v
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[3~' delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search
bindkey '^[[D' backward-char
bindkey '^[[C' forward-char 
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^v' edit-command-line

# syntax highlighting
. /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# "command not found"
. /usr/share/doc/pkgfile/command-not-found.zsh

# disable ctrl+s/ctrl+q
stty -ixon -ixoff

# man
man () {
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

# ranger
ranger ()
{
    tempfile="$(mktemp -t tmp.XXXXXX)"
    SHELL=$HOME/scripts/r.shell /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"

    test -f "$tempfile" &&
        if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
            cd -- "$(cat "$tempfile")"
        fi
    rm -f -- "$tempfile"
}

sudo_ranger ()
{
    sudo SHELL=$HOME/scripts/r.shell /usr/bin/ranger "${@:-$(pwd)}"
}

tx ()
{
    if [[ -o interactive ]] && [[ ! "$TERM" =~ "screen" ]] && [[ ! "$TERM" =~ "tmux" ]] && [ -z "$TMUX" ]
    then tmux attach || . $HOME/scripts/tmux-default-session.sh; fi
}

# color grid
colorgrid ()
{
    local iter=16
    while [ $iter -lt 52 ]
    do
        local second=$(($iter+36))
        local third=$(($second+36))
        local four=$(($third+36))
        local five=$(($four+36))
        local six=$(($five+36))
        local seven=$(($six+36))
        if [ $seven -gt 250 ]; then seven=$(($seven-251)); fi

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
if [ "$TERM" = "yaft-256color" ]
then
    if [ -f /tmp/tmux-refresh-service-$(whoami)/tmp ]
    then
        echo $(tty) > /tmp/tmux-refresh-service-$(whoami)/$(cat /tmp/tmux-refresh-service-$(whoami)/tmp)
        rm /tmp/tmux-refresh-service-$(whoami)/tmp
    fi

    tx
    exit
fi

# unfreeze terminal if left frozen
ttyctl -f

# shell prompt
. $HOME/.zshrc.prompt

