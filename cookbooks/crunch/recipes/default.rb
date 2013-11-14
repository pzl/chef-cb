#Crunchbang-specific setup


#get rid of folders I don't want
%w{backup music templates videos}.each do |dir|
	directory "/home/dan/#{dir}" do
		action :delete
	end
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
	not_if { ::File.exists? "/home/dan/.config/.autologin"}
end

cookbook_file "/home/dan/.config/.autologin" do
	source ".autologin"
	owner "dan"
	group "dan"
	mode 0644
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
