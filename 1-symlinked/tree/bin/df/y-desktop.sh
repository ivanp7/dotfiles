#!/bin/sh

# request display of shell info
PIDFILE="$TMPDIR_CURRENT/shell_info$(tty)/$PARENT_SHELL_PID_EXPORTED"
[ -n "$PARENT_SHELL_PID_EXPORTED" -a -f "$PIDFILE" ] && rm "$PIDFILE" || true

WALLPAPER=$HOME/wallpapers/yaft

if [ -e "$WALLPAPER" ] && file -b -i "$WALLPAPER" | grep -q "^image/"
then screen -c $XDG_CONFIG_HOME/screen/screenrc_noui yaft_wall "$WALLPAPER";
else screen -c $XDG_CONFIG_HOME/screen/screenrc_noui yaft;
fi

clear

