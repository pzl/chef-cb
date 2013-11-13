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
	#todo only run if backports was a new addition?
end


#openbox autostart
cookbook_file "/home/dan/.config/openbox/autostart" do
	source "autostart.sh"
	mode 0755
	owner "dan"
	group "dan"
end


#auto login slim.conf
#no, I /REALLY/ don't want to manage that whole file
ruby_block "enable auto login" do
	block do
		f = Chef::Util::FileEdit.new("/etc/slim.conf")
		f.search_file_replace_line(
			/^\#default_user\s+.*$/i,
			"default_user	dan"
		)
		f.search_file_replace_line(
			/^\#?auto_login\s+no\s*/i,
			"auto_login	yes"
		)
		f.write_file
	end
end

#bashrc
#todo: move to dotfiles recipe?
cookbook_file "/home/dan/.bashrc" do
	source ".bashrc"
	mode 0644
	owner "dan"
	group "dan"
end

#todo

#bin

#sidebar folders in thunar -- move to theming?
