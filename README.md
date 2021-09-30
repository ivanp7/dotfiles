Dotfiles
--------

# Rules of application

1) Run `install.sh` as root without arguments

2) Repeat for each desired plugin, now passing plugin names one at a time

3) Run `/usr/local/share/dotfiles/install.sh` as users, for which you want to install dotfiles

4) Repeat last step for all desired plugins, but run `/usr/local/share/<plugin name>/install.sh` this time

5) To uninstall dotfiles for a user, run `/usr/local/share/dotfiles/uninstall.sh` as that user

6) Repeat for each plugin to be uninstalled, but run `/usr/local/share/<plugin name>/uninstall.sh` this time

