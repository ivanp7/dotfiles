s/-(-|[+])-/---/g;
s/^---//;
s/---pstree$//;
s/sshd(---sshd)*/(ssh)/g;
s/tmux: server/(tmux)/g; s/screen(---screen)*/(screen)/g;
s/y-desktop\.sh---\(screen\)---yaft/(yaft)/;
