#!/bin/sh

[[ -f ~/.config/.Xresources ]] && xrdb -merge ~/.config/.Xresources

case $1 in
	openbox-session)
		exec openbox-session;;
	bspwm|*)
		eval `dbus-launch --sh-syntax --exit-with-session`
		xsetroot -cursor_name left_ptr #bspwm uses default X11 cursor, an X
		hsetroot -solid "#2E3436" #solid color bg if wallpaper fails
		nitrogen --restore #wallpaper
		compton --config ~/.config/compton.conf -b #compositor
		eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &
		sxhkd & #keybindings
		thunar --daemon & #file manager
		xfce4-volumed & #volume keys daemon
		xfce4-power-manager & #power manager bus?


		if egrep -iq 'touchpad' /proc/bus/input/devices; then
			synclient VertEdgeScroll=1 &
			synclient TapButton1=0 &
		fi
		#if egrep -iq 'Apple Keyboard' /proc/bus/input/devices; then
			#echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
		#fi
		if egrep -iq 'Razer Naga' /proc/bus/input/devices; then
			if ! pidof nagad; then
				nagad &
			fi
			#if ! pidof razerd; then
			#	sudo razerd &
			#fi
		fi
		xscreensaver -no-splash &
		xset r rate 250 25 &
		xset b off &

		#tint stuff
		tint2 &
		nm-applet &
		pnmixer &

		conky -q -c ~/.config/conky/conky-bar &

		exec ssh-agent ck-launch-session bspwm
		#or exec dbus-launch --sh-syntax --exit-with-session bspwm > ~/.config/bspwm/session.log 2>&1
		#or just exec bspwm
		;;
esac
