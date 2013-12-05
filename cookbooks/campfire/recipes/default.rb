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


#todo move to .config/weechat using weechat -d (need to set alias in bash from here?)
directory "#{node[:user][:home]}/.weechat" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end


#buffers.pl
# alternatively find a way to use `weechat -r` to run /script add on these
directory "#{node[:user][:home]}/.weechat/perl" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end
# when creating recursively, chown only applies to leaf!
directory "#{node[:user][:home]}/.weechat/perl/autoload" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end
remote_file "#{node[:user][:home]}/.weechat/perl/buffers.pl" do
	source "http://www.weechat.org/files/scripts/buffers.pl"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end
link "#{node[:user][:home]}/.weechat/perl/autoload/buffers.pl" do
	to "#{node[:user][:home]}/.weechat/perl/buffers.pl"
	owner node[:user][:name]
	group node[:user][:name]
end
template "#{node[:user][:home]}/.weechat/weechat.conf" do
	source "weechat.conf"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
	backup false
	variables({
		:nick => node[:user][:name] #change
	})
end
template "#{node[:user][:home]}/.weechat/buffers.conf" do
	source "buffers.conf"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
	backup false
end
template "#{node[:user][:home]}/.weechat/irc.conf" do
	source "irc.conf"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
	backup false
	variables({
		:nick => node[:user][:name], #change
		:domain => "sample",
		:key => "1234567890"
	})
end

#more config
#http://dotshare.it/dots/140/
#http://dotshare.it/dots/395/
