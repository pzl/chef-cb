#todo: x-platform

#https://toolbelt.heroku.com/install-ubuntu.sh
execute "install-heroku-key" do
	command "wget -O- https://toolbelt.heroku.com/apt/release.key | apt-key add -"
	not_if { ::File.exists? "/etc/apt/sources.list.d/heroku.list" }
end

cookbook_file "/etc/apt/sources.list.d/heroku.list" do
	source "heroku.list"
	mode 0644
	owner "root"
	group "root"
	notifies :run, "execute[update-heroku]", :immediately
end

execute "update-heroku" do
	command "apt-get update"
	action :nothing
end

package "heroku-toolbelt" do
	action :install
end