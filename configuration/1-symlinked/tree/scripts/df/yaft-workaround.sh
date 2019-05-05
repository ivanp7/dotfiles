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

