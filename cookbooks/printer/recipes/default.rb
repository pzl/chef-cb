
#python libs as listed here: https://github.com/kliment/Printrun
package 'python-psutils'
package 'python-cairo'
package 'python-cairosvg'
package 'python-numpy'
package 'python-serial'
package 'python-wxgtk2.8'
package 'python-pyglet'
package 'python-tornado'
package 'python-setuptools'
package 'python-libxml2'
package 'python-gobject'
package 'avahi-daemon'
package 'libavahi-compat-libdnssd1'

#@todo: setup memory-conservative gcode parser


#@todo: arduino env for flashing marlin
#copy arduinoaddons to arduino libraries folder
#add settings/changes to marlin
#edit pins.h BEEPER 79 to BEEPER -1 to save my ears


git "#{Chef::Config[:file_cache_path]}/Printrun" do
	repository "https://github.com/kliment/Printrun.git"
	action :checkout
	notifies :run, "execute[install printrun]"
	not_if { ::File.exists? "/usr/local/bin/pronterface" }
end

git "#{Chef::Config[:file_cache_path]}/Slic3r" do
	repository "https://github.com/alexrj/Slic3r.git"
	action :checkout
	notifies :run, "execute[install slic3r]"
	not_if { ::File.exists? "/usr/local/bin/slic3r" }
end




execute "install printrun" do
	command <<-EOH
		ln -s /usr/local/bin/pronterface #{Chef::Config[:file_cache_path]}/Printrun/pronterface.py
		ln -s /usr/local/bin/pronsole #{Chef::Config[:file_cache_path]}/Printrun/pronsole.py
		ln -s /usr/local/bin/printcore #{Chef::Config[:file_cache_path]}/Printrun/printcore.py
		ln -s /usr/local/bin/plater	#{Chef::Config[:file_cache_path]}/Printrun/plater.py
	EOH
	creates "/usr/local/bin/pronterface"
	action :nothing
end

execute "install slic3r" do
	cwd "#{Chef::Config[:file_cache_path]}/Slic3r"
	command <<-EOH
		perl Build.PL
		perl Build.PL --gui
		ln -s /usr/local/bin/slic3r #{Chef::Config[:file_cache_path]}/Slic3r/slic3r.pl
	EOH
	creates "/usr/local/bin/slic3r"
	action :nothing
end




template "/etc/udev/rules.d/10-MendelMax.rules" do
	source "10-MendelMax.rules"
	owner "root"
	group "root"
	mode 0644
	variables(
		:group => node[:user][:name]
	)
	notifies :run, "execute[udev-3dprint]", :immediately
end

execute "udev-3dprint" do
	command <<-EOH
		udevadm control --reload-rules
		udevadm trigger
	EOH
	action :nothing
end