#Rigol scope
#todo: target product instead of whole driver

template "/etc/udev/rules.d/10-Rigol.rules" do
	source "10-Rigol.rules"
	owner "root"
	group "root"
	mode 0644
	notifies :run, "execute[udev-rigol]", :immediately
end

execute "udev-rigol" do
	command <<-EOH
		udevadm control --reload-rules
		udevadm trigger
	EOH
	action :nothing
end