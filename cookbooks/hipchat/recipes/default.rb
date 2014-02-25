execute "hipchat-key" do
	command "wget -O - https://www.hipchat.com/keys/hipchat-linux.key | apt-key add -"
	not_if { ::File.exists? "/etc/apt/sources.list.d/hipchat.list" }
end

cookbook_file "/etc/apt/sources.list.d/hipchat.list" do
	source "hipchat.list"
	mode 0644
	owner "root"
	group "root"
	notifies :run, "execute[update-hipchat]", :immediately
end

execute "update-hipchat" do
	command "apt-get update"
	action :nothing
end

package "hipchat" do
	action :install
end