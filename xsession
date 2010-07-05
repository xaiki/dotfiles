#!/bin/sh
export LANG=en_US.UTF-8
export XA1_WM="E_PREFIX=/usr enlightenment_start"

setxkbmap dvorak &
$XA1_WM &
gnome-terminal & #xcompmgr -n & nautilus -n &
gnome-settings-daemon &
gnome-keyring-daemon &
gnome-volume-manager &
# gnome-panel &
# gnome-power-manager &
xset b off &

#for i in `grep OnlyShowIn=GNOME /etc/xdg/autostart/*.desktop | sed s/':'/' '/g | awk {'print $1'}`; do grep 'Exec=' $i | sed s/'Exec='// | sh & echo $i; done
#cat .config/autostart/*.desktop | grep Exec | sed s/'Exec='// | sed s/$/' \&'/g | sh

~/bin/pause







