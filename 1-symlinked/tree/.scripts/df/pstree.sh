#!/bin/sh

pstree -ls $$ | head -1 | sed -E "
    s/-(-|[+])-/---/g; 
    s/^(runit|systemd)(|---runsvdir---runsv)(|---login)//;
    s/---pstree\.sh---head$//;
    s/---(|z|ba|da)sh//g;
    s/^---//;
    s/sshd(---sshd)*/ssh/g;
    s/tmux: server/tmux/g; s/screen(---screen)*/screen/g;
    s/y-desktop\.sh---screen---yaft/yaft/;
"

