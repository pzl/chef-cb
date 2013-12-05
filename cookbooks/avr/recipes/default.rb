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


#todo
#TTYS1 rules & reload udev
#tolerate usb to serial