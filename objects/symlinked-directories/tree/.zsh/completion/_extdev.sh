#compdef extdev.sh

_extdev_sh ()
{
    _arguments \
        "1:Command:(list mount unmount)" \
        "2:Device:($(lsblk -lsd | tail -n+2 | cut -d' ' -f1))"
}

_extdev_sh

