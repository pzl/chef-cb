package 'irssi'
package 'ruby1.9.3'
gem_package 'camper_van'
package 'libssl-dev'

#camper_van/lib/camper_van/channel.rb => paste handling

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