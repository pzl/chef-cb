cookbook_file "vbox-backports" do
	path "/etc/apt/sources.list.d/wheezy-backports.list"
	source "wheezy-backports.list"
	cookbook "apt"
	mode 0644
	owner "root"
	group "root"
	action :create_if_missing
	notifies :run, "execute[apt-update-vbox]", :immediately
end

execute "apt-update-vbox" do
	command "apt-get update"
	action :nothing
end

execute "apt-install-virtualbox" do
	command "apt-get -q -y install -t wheezy-backports virtualbox"
	action :run
	creates "/usr/bin/virtualbox"
end

#bug: tries to pre-fetch version from stable repos
#package "virtualbox" do
#	options "-t wheezy-backports"
#end