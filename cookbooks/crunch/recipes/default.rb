#Crunchbang-specific setup
package 'gtk2-engines-pixbuf' #https://bugs.launchpad.net/ubuntu/+source/light-themes/+bug/762167


#get rid of folders I don't want
%w{backup music templates videos}.each do |dir|
	directory "#{node[:user][:home]}/#{dir}" do
		action :delete
		recursive true
	end
end

directory "#{node[:user][:home]}/dev" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end

#openbox autostart
cookbook_file "#{node[:user][:home]}/.config/openbox/autostart" do
	source "autostart.sh"
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
end


#auto login slim.conf
#no, I /REALLY/ don't want to manage that whole file
ruby_block "enable auto login" do
	block do
		f = Chef::Util::FileEdit.new("/etc/slim.conf")
		f.search_file_replace_line(
			/^\#default_user\s+.*$/i,
			"default_user	#{node[:user][:name]}"
		)
		f.search_file_replace_line(
			/^\#?auto_login\s+no\s*/i,
			"auto_login	yes"
		)
		f.write_file
	end
	not_if { ::File.exists? "#{node[:user][:home]}/.config/.autologin"}
end

cookbook_file "#{node[:user][:home]}/.config/.autologin" do
	source ".autologin"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

#bashrc
#todo: move to dotfiles recipe?
cookbook_file "#{node[:user][:home]}/.bashrc" do
	source ".bashrc"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
end

cookbook_file "/root/.bashrc" do
	source ".bashrc"
	mode 0644
	owner "root"
	group "root"
end

#todo
#bin
#dev?