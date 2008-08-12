#!/bin/sh
export LANG=en_US.UTF-8

setxkbmap dvorak &
#e16 & 
awesome & gnome-terminal & xcompmngr -cnf &
gnome-settings-daemon &
gnome-keyring-daemon &
gnome-volume-manager &
#gnome-panel &
gnome-power-manager &
mail-notification &
xset b off & 

for i in `grep OnlyShowIn=GNOME /etc/xdg/autostart/*.desktop | sed s/':'/' '/g | awk {'print $1'}`; do grep 'Exec=' $i | sed s/'Exec='// | sh & echo $i; done
cat .config/autostart/*.desktop | grep Exec | sed s/'Exec='// | sed s/$/' \&'/g | sh
#python /usr/share/screenlets/Clock/ClockScreenlet.py & 
#urxvtd &
#xbindkeys & 


~/bin/pause

