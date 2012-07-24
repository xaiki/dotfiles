#!/bin/sh
if test -z $XA1_LAUNCHED; then
	export XA1_LAUNCHED=1
	export LANG=en_US.UTF-8
	export XA1_WM="awesome"

	ck-launch-session sh $0
	~/bin/pause
	exit
fi

#xcompmgr -cnf -D3&
gnome-terminal &
gnome-settings-daemon &
gnome-keyring-daemon &
gnome-volume-manager &
# gnome-panel &
gnome-power-manager &
xset b off &

$XA1_WM &

for i in `grep OnlyShowIn=GNOME /etc/xdg/autostart/*.desktop | cut -d':' -f1 && ls .config/autostart/*.desktop | xargs -n1`; do
	echo "$i";
	r=`grep 'Exec=' $i | cut -d'=' -f2`;
	$r;
done

setxkbmap dvorak -option compose:caps &
xmodmap ~/.xmodmap &
