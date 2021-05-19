#!/bin/sh

[ "$TERM" = "linux" ] || exit

# request display of shell info
PIDFILE="$TMPDIR_CURRENT/shell_info/$(tty)/$PARENT_SHELL_PID_EXPORTED"
[ -n "$PARENT_SHELL_PID_EXPORTED" -a -f "$PIDFILE" ] && rm "$PIDFILE" || true

WALLPAPER="$HOME/wallpapers/fbterm"

if [ -e "$WALLPAPER" ] && file --mime-type "$WALLPAPER" -bLE | grep -q "^image/"
then
    echo -ne "\e[?25l" # hide cursor
    fbv -ciuker "$WALLPAPER" << EOF
q
EOF
    export FBTERM_BACKGROUND_IMAGE=1
fi

exec fbterm -n "$DEFAULT_FONT_NAME" -s "$DEFAULT_FONT_SIZE" -- "$HOME/.scripts/df/fbterm.sh" "$1"

