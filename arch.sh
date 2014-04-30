#!/bin/bash

#get path to cookbooks
HERE="`dirname $0`"
HERE="`(cd \"$HERE\" && pwd )`"
if [ -z "$HERE" ]; then
	echo "couldn't determine chef path"
	exit 1
fi
HERE="$HERE/cookbooks"


#bin scripts
cp "$HERE/bin/templates/default/*" "~/bin/"


#bspwm and X things
mkdir -p ~/.config/bspwm/
mkdir -p ~/.config/sxhkd
cp "$HERE/bspwm/templates/debian/.xinitrc" ~/
cp "$HERE/bspwm/templates/debian/bspwmrc" ~/.config/bspwm/
chmod +x ~/.config/bspwm/bspwmrc
sed -i "s/\<\%\= \@home \=\>/\/home\/$USER/" ~/.config/bspwm/bspwmrc
cp "$HERE/bspwm/templates/debian/sxhkdrc" ~/.config/sxhkd
cp "$HERE/bspwm/templates/debian/tiling_rules" ~/bin
cp "$HERE/bspwm/templates/debian/winfo" ~/bin

#the conky
cp -r "$HERE/conky/templates/debian/conky" ~/.config


#home stuff
cp "$HERE/crunch/files/default/.bashrc" ~/
mkdir -p ~/dev
mkdir -p ~/documents
mkdir -p ~/tmp

#git
cp "$HERE/git/files/default/.git*" ~/


#theme things
mkdir -p ~/images/wallpapers
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/Thunar
mkdir -p ~/.config/terminator
mkdir -p ~/.config/tint2
cp "$HERE/theme/files/default/*" ~/images/wallpapers/
cp "$HERE/theme/templates/debian/.Xresources" ~/.config/
cp "$HERE/theme/templates/debian/.gtk-bookmarks" ~/.config/
cp "$HERE/theme/templates/debian/.gtkrc-2.0" ~/.config/
cp "$HERE/theme/templates/debian/colorconfig" ~/.config/
cp "$HERE/theme/templates/debian/compton.conf" ~/.config/
cp "$HERE/theme/templates/debian/gtk-3-settings" ~/.config/gtk-3.0/settings.ini
cp "$HERE/theme/templates/debian/sc" ~/bin
cp "$HERE/theme/templates/debian/terminator-config" ~/.config/terminator/config
cp "$HERE/theme/templates/debian/thunarrc" ~/.config/Thunar
cp "$HERE/theme/templates/debian/tint2rc" ~/.config/tint2
cp "$HERE/theme/templates/debian/uca.xml" ~/.config/Thunar


#vim
cp "$HERE/vim/files/default/.vimrc" ~/



#nitrogen ~/images/wallpapers &
#lxappearance
#sudo lxappearance
#qtconfig-qt4
#sudo qtconfig-qt4



#dont forget to add ~/bin to PATH in /etc/profile


#general
chmod +x ~/bin/*

