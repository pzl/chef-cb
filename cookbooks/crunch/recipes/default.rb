#cat lib/sources.list | sudo tee -a /etc/apt/sources.list
#sudo apt-get update
#sudo apt-get upgrade
#sudo apt-get dist-upgrade

#ln -s ~/.bashrc lib/dotfiles/.bashrc
#ln -s ~/.config/openbox/autostart lib/autostart


#bin


## IO HACKS
#turn off 'fn' for apple keyboard
#echo 0 | sudo tee /sys/module/hid_apple/parameters/fnmode
#turn off tap-to-click for trackpads
#synclient TapButton1=0



#/etc/slim.conf
#default_user dan
#auto_login yes