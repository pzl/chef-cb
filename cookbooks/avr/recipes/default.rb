package 'gcc-avr'
package 'avr-libc'
package 'binutils-avr'
package 'avrdude'

cookbook_file "/home/dan/.avrduderc" do
	source ".avrduderc"
	mode 0644
	owner "dan"
	group "dan"
end


#todo
#TTYS1 rules & reload udev
#tolerate usb to serial