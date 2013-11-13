package "wireshark-common" do
	notifies :run, "execute[wireshark-reconfigure]", :immediately
	notifies :modify, "group[wireshark]", :immediately
end

execute "wireshark-reconfigure" do
	command <<-EOH
	echo "set wireshark-common/install-setuid true" | debconf-communicate
	dpkg-reconfigure -fnoninteractive wireshark-common
	EOH
	action :nothing
end

group "wireshark" do
	append true
	members "dan"
	action :nothing
end

#group change doesn't take effect until restart