cookbook_file "/etc/apt/sources.list.d/wheezy-backports.list" do
	source "wheezy-backports.list"
	mode 0644
	owner "root"
	group "root"
	action :create_if_missing
	notifies :run, "execute[apt-update]", :immediately
end

execute "apt-update" do
	command "apt-get update"
	action :nothing
end

execute "apt-install-nginx" do
	command "apt-get -q -y install -t wheezy-backports nginx-extras"
	action :run
	not_if { ::File.exists? "/usr/sbin/nginx" }
end

#bug: tries to pre-fetch version from stable repos
#package "nginx-extras" do
#	options "-t wheezy-backports"
#end

#future: could compile with explicitly needed packages