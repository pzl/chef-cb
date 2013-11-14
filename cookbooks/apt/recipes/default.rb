#stops apt from indexing a thousand en_US packages, half of which fail
cookbook_file "/etc/apt/apt.conf.d/99translations" do
	mode 0644
	owner "root"
	group "root"
	source "99translations"
end

#add backports to sources
cookbook_file "/etc/apt/sources.list.d/wheezy-backports.list" do
	source "wheezy-backports.list"
	mode 0644
	owner "root"
	group "root"
	notifies :run, "execute[apt-get-update]", :immediately
	#notify other rsrc that backports are enabled? or test for backports in them
end

execute "apt-get-update" do
	command "apt-get update"
	action :nothing
end