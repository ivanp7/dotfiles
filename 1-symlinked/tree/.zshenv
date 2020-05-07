# PATH
typeset -U path
path+=($HOME/bin/df $HOME/bin/xdf $HOME/bin $HOME/bin/local $HOME/.roswell/bin)

# default applications

export PAGER=/usr/share/vim/vim82/macros/less.sh
export EDITOR=/usr/bin/vim
export VISUAL=$EDITOR
export FILE=lfcd

export TERMINAL=/usr/bin/st
export VIEWER=/usr/bin/sxiv
export PLAYER=/usr/bin/mpv
export PDFVIEWER=/usr/bin/zathura
export BROWSER=/usr/bin/surf

# default font
if [ -r "$HOME/.default_font" ]
then export DEFAULT_FONT=$(cat "$HOME/.default_font")
else export DEFAULT_FONT="xos4 Terminus:size=10"
fi

# fixes for things
export GNUMAKEFLAGS=--no-print-directory

