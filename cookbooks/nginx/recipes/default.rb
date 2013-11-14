cookbook_file "backports-nginx" do
	path "/etc/apt/sources.list.d/wheezy-backports.list"
	source "wheezy-backports.list"
	cookbook "apt"
	mode 0644
	owner "root"
	group "root"
	action :create_if_missing
	notifies :run, "execute[apt-update-nginx]", :immediately
end

execute "apt-update-nginx" do
	command "apt-get update"
	action :nothing
end

execute "apt-install-nginx" do
	command "apt-get -q -y install -t wheezy-backports nginx-extras"
	action :run
	creates "/usr/sbin/nginx"
end

#bug: tries to pre-fetch version from stable repos
#package "nginx-extras" do
#	options "-t wheezy-backports"
#end

#future: could compile with explicitly needed packages