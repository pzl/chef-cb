#maybe use apt LWRP in the future

#@todo: disable journaling -- nojournal=true in /etc/mongodb.conf
#@todo turn off start on boot, or start after install

execute "install-mongo-key" do
	command "apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
	not_if { ::File.exists? "/etc/apt/sources.list.d/10gen.list" }
end

cookbook_file "/etc/apt/sources.list.d/10gen.list" do
	source "10gen.list"
	mode 0644
	owner "root"
	group "root"
	action :create_if_missing
	notifies :run, "execute[update-mongo]", :immediately
end

execute "update-mongo" do
	command "apt-get update"
	action :nothing
end

package "mongodb-10gen" do
	action :install
end