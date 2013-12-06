#Razer naga hotkeys
git "#{Chef::Config[:file_cache_path]}/nagad" do
	repository "https://github.com/pzl/Razer-Naga-HotKey.git"
	action :checkout
	notifies :run, "execute[build nagad]", :immediately
	not_if { ::File.exists? "/usr/local/bin/nagad" }
end

execute "build nagad" do
	cwd "#{Chef::Config[:file_cache_path]}/nagad"
	command "make && make install"
	action :nothing
	creates "/usr/local/bin/nagad"
end

files = [
	"button_1",
	"button_2",
	"button_3",
	"button_4",
	"button_5",
	"button_6",
	"button_7",
	"button_8",
	"button_9",
	"button_10",
	"button_11",
	"button_12",
	"log"
]

directory "#{node[:user][:home]}/.naga" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end

files.each do |f|
	template "#{node[:user][:home]}/.naga/#{f}" do
		source f
		owner node[:user][:name]
		group node[:user][:name]
		mode 0755
		backup false
	end
end


#razercfg
package 'python2.7'
package 'cmake'
package 'libusb-1.0.0-dev'
package 'python-qt4' #optional dep. for graphical qrazercfg


git "#{Chef::Config[:file_cache_path]}/razercfg" do
	repository "https://github.com/mbuesch/razer.git"
	action :checkout
	notifies :run, "execute[razercfg make]", :immediately
	not_if { ::File.exists? "/usr/local/bin/razercfg" }
end

execute "razercfg make" do
	cwd "#{Chef::Config[:file_cache_path]}/razercfg"
	command <<-EOH
		cmake .
		make
		make install
	EOH
	action :nothing
	creates "/usr/local/bin/razercfg"
end

#todo init scripts for razerd
#or put into autostart (needs root?)