package 'gcc-avr'
package 'avr-libc'
package 'binutils-avr'
package 'avrdude'

template "#{node[:user][:home]}/.avrduderc" do
	source ".avrduderc"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
end

template "/etc/udev/rules.d/99-serial.rules" do
	source "99-serial.rules"
	mode 0644
	variables(
		:group => node[:user][:name]
	)
	notifies :run, "execute[udev avrdude]", :immediately
end

execute "udev avrdude" do
	command <<-EOH
		udevadm control --reload-rules
		udevadm trigger
	EOH
	action :nothing
end


#todo
#tolerate usb to serial