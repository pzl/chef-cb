#package 'irssi'
#package 'weechat'
package 'ruby1.9.1-dev'
package 'libssl-dev'
gem_package 'camper_van'
gem_package 'eventmachine'

#camper_van/lib/camper_van/channel.rb => paste handling


cookbook_file "backports-weechat" do
	path "/etc/apt/sources.list.d/wheezy-backports.list"
	source "wheezy-backports.list"
	cookbook "apt"
	mode 0644
	owner "root"
	group "root"
	action :create_if_missing
	notifies :run, "execute[apt-update-weechat]", :immediately
end

execute "apt-update-weechat" do
	command "apt-get update"
	action :nothing
end

execute "apt-install-weechat" do
	command "apt-get -q -y install -t wheezy-backports weechat"
	action :run
	creates "/usr/bin/weechat"
end

#bug: tries to pre-fetch version from stable repos
#package "weechat" do
#	options "-t wheezy-backports"
#end

#future: could compile with explicitly needed packages

=begin
directory "#{node[:user][:home]}/.irssi" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end

#maybe find a way to do .config/irssi/config?
template "#{node[:user][:home]}/.irssi/config" do
	source "irssi.config.erb"
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
	backup false
	variables ({
		:campfire_subdomain => "sample",
		:campfire_token => "12345690",
		:campfire_auto_rooms => ["botdev"],
		:real_name => "Dan Panzarella",
		:uname => "dan_panzarella",
		:nick => "dan_panzarella"
	})
end
=end

