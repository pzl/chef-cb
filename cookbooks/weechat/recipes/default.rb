pacakge 'weechat'

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
		:nick => "pzl" #set in attributes
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
		:nick => "pzl" #have bootstrap prompt for password?
	})
end
