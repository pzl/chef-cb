#chrome yay
google_key_url_1='https://dl-ssl.google.com/linux/linux_signing_key.pub'
google_key_url_2='http://packages.crunchbang.org/waldorf-files/apt-keys/google-chrome.key'

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
	notifies :run, "execute[update]", :immediate
end

execute "update" do
	command "apt-get update"
	action :nothing
end

package "google-chrome-stable" do
	action :install
end

#add more configs

cookbook_file "/home/dan/.config/google-chrome/Default/Bookmarks" do
	source "bookmark"
	owner "dan"
	group "dan"
	action :create_if_missing
	mode 0600
end

#talk plugin.deb
