#Crunchbang-specific setup

#add backports to sources
cookbook_file "/etc/apt/sources.list.d/wheezy-backports.list" do
	source "wheezy-backports.list"
	mode 0644
	owner "root"
	group "root"
	#notify other rsrc that backports are enabled? or test for backports in them
end
#update sources
bash "apt update" do
	code "apt-get update"
end

#move to a dotfiles recipe?
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