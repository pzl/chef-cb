## Openbox autostart.sh
## ====================
## When you login to your CrunchBang Openbox session, this autostart script 
## will be executed to set-up your environment and launch any applications
## you want to run at startup.
##
## Note*: some programs, such as 'nm-applet' are run via XDG autostart.
## Run '/usr/lib/openbox/openbox-xdg-autostart --list' to list any
## XDG autostarted programs.
##
## More information about this can be found at:
## http://openbox.org/wiki/Help:Autostart
##
## If you do something cool with your autostart script and you think others
## could benefit from your hack, please consider sharing it at:
## http://crunchbang.org/forums/
##
## Have fun & happy CrunchBangin'! :)

## GNOME PolicyKit and Keyring
eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &

## Set root window colour
hsetroot -solid "#2E3436" &

#xrandr --output DFP10 --mode 1440x900 --output DFP11 --mode 1920x1080 --primary --left-of DFP10


## Group start:
## 1. nitrogen - restores wallpaper
## 2. compositor - start
## 3. sleep - give compositor time to start
## 4. tint2 panel
(\
nitrogen --restore && \
#cb-compositor --start && \
#sleep 2s && \
tint2 \
) &


## Volume control for systray
(sleep 2s && pnmixer) &

## Volume keys daemon
xfce4-volumed &

## Enable power management
xfce4-power-manager &

## Start Thunar Daemon
thunar --daemon &

## Detect and configure touchpad. See 'man synclient' for more info.
if egrep -iq 'touchpad' /proc/bus/input/devices; then
    synclient VertEdgeScroll=1 &
    synclient TapButton1=0 &
fi

#toggle 'fn' key on apple keyboards
echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode

## Start xscreensaver
xscreensaver -no-splash &

## Start Clipboard manager
#(sleep 3s && clipit) &

## Set keyboard settings - 250 ms delay and 25 cps (characters per second) repeat rate.
## Adjust the values according to your preferances.
xset r rate 250 25 &

## Turn on/off system beep
xset b off &

## The following command runs hacks and fixes for #! LiveCD sessions.
## Safe to delete after installation.
#cb-cowpowers &

## cb-welcome - post-installation script, will not run in a live session and
## only runs once. Safe to remove.
# (sleep 10s && cb-welcome --firstrun) &

## cb-fortune - have Waldorf say a little adage
#(sleep 120s && cb-fortune) &

## Run the conky
conky -q &
conky -q -c ~/.conky/conky-bar &

#perma-f keys mode, and open gfx driver
terminator -e "echo 0 | sudo tee -a /sys/module/hid_apple/parameters/fnmode; sudo amdcccle"

#razer naga key listening
nagad &


(sleep 3s && terminator -b -m) &