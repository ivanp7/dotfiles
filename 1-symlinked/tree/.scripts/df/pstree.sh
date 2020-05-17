#!/bin/sh

pstree -ls $$ | head -n 1 | sed -E "
    s/-.-/---/g; 
    s/systemd//;
    s/---login//;
    s/---pstree\.sh//;
    s/---head//;
    s/---sh//g;
    s/---dash//g;
    s/---zsh//g;
    s/---bash//g;
    s/---startx//g;
    s/---xinit//g;
    s/---dwm//g;
    s/---x-desktop\.sh//g;
    s/---dropdown-termin//g;
    s/^---//;
    s/sshd(---sshd)*/ssh/;
    s/tmux: server/tmux/;
    s/screen(---screen)*/screen/;
    s/y-desktop\.sh---screen---yaft/yaft/;
"

