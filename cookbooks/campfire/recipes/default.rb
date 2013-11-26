package 'irssi'
package 'ruby1.9.1-dev'
package 'libssl-dev'
gem_package 'camper_van'
gem_package 'eventmachine'

#camper_van/lib/camper_van/channel.rb => paste handling

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