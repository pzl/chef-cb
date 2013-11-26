#chrome yay
google_key_url_1='https://dl-ssl.google.com/linux/linux_signing_key.pub'
google_key_url_2='http://packages.crunchbang.org/waldorf-files/apt-keys/google-chrome.key'
talkplugin_url='https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb'

execute "install-google-key" do
	command "wget -O- #{google_key_url_1} | apt-key add -"
	not_if { ::File.exists? "/etc/apt/sources.list.d/google-chrome.list" }
end

cookbook_file "/etc/apt/sources.list.d/google-chrome.list" do
	source "google-chrome.list"
	owner "root"
	group "root"
	mode 0644
	action :create_if_missing
	notifies :run, "execute[update-goog]", :immediately
end

execute "update-goog" do
	command "apt-get update"
	action :nothing
end

package "google-chrome-stable" do
	action :install
end

#add more configs

cookbook_file "#{node[:user][:home]}/.config/google-chrome/Default/Bookmarks" do
	source "bookmark"
	owner node[:user][:name]
	group node[:user][:name]
	action :create_if_missing
	mode 0600
end

#talk plugin.deb
cookbook_file "/etc/apt/sources.list.d/google-talkplugin.list" do
	source "google-talkplugin.list"
	owner "root"
	group "root"
	mode 0644
	action :create_if_missing
	notifies :run, "execute[update-goog]", :immediately
end

package "google-talkplugin" do
	action :install
end