#compdef remote.sh

_remote_sh ()
{
    _arguments \
        "1:Host:($(ls $HOME/.password-store/computers/ 2> /dev/null))" \
        "2:Mode:(get_url status wakeup upload wakeup-upload download wakeup-download mount wakeup-mount unmount command wakeup-command tunnel wakeup-tunnel)"
}

_remote_sh

