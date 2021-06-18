s/-(-|[+])-/---/g;
s/^---//;
s/---lf\.sh//;
s/---pstree$//;
s/sshd(---sshd)*/(ssh)/g;
s/tmux: server/(tmux)/g; s/screen(---screen)*/(screen)/g;
