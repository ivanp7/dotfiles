#compdef external-drive.sh

_external_drive_sh ()
{
    _arguments \
        "1:Command:(mount unmount)" \
        "2:Partition:($(lsblk -lsd | tail -n+2 | cut -d' ' -f1))"
}

_external_drive_sh

