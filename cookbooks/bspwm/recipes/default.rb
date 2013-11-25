package "xcb"
package "libxcb-util0-dev"
package "libxcb-ewmh-dev"
package "libxcb-randr0-dev"
package "libxcb-icccm4-dev"
package "libxcb-keysyms1-dev"
package "gcc"
package "make"

git "#{Chef::Config[:file_cache_path]}/bspwm" do
	repository "https://github.com/baskerville/bspwm.git"
	action :checkout
	notifies :run, "execute[install bspwm]", :immediately
end

git "#{Chef::Config[:file_cache_path]}/sxhkd" do
	repository "https://github.com/baskerville/sxhkd.git"
	action :checkout
	notifies :run, "execute[install sxhkd]", :immediately
end


execute "install bspwm" do
	cwd "#{Chef::Config[:file_cache_path]}/bspwm"
	command <<-EOH
		make
		make install
	EOH
	action :nothing
end

execute "install sxhkd" do
	cwd "#{Chef::Config[:file_cache_path]}/sxhkd"
	command <<-EOH
		make
		make install
	EOH
	action :nothing
end

ruby_block "enable xinitrc, add bspwm to session list" do
	block do
		#f = Chef::Util::FileEdit.new("/etc/slim.conf")
		f = IO.read("/etc/slim.conf")
		#disable old session command
		f.gsub!(
			/^login_cmd\s+.*Xsession\s+%session/i,
			'# \0'
		)
		#uncomment xinitrc method
		f.gsub!(
			/^\#\s*(login_cmd\s+.*xinitrc\s+%session)/i,
			'\1'
		)
		#add bspwm to session list
		f.gsub!(
			/^sessions\s+openbox-session/i,
			'\0,bspwm'
		)
		File.open('/etc/slim.conf','w') { |file| file.puts f }
		#f.write_file
	end
	not_if { ::File.exists? "/home/dan/.config/bspwm/bspwmrc"}
end

directory "/home/dan/.config/bspwm" do
	owner "dan"
	group "dan"
	mode 0755
end

directory "/home/dan/.config/sxhkd" do
	owner "dan"
	group "dan"
	mode 0755
end

template "/home/dan/.config/bspwm/bspwmrc" do
	source "bspwmrc.erb"
	owner "dan"
	group "dan"
	mode 0755
end

template "/home/dan/.config/sxhkd/sxhkdrc" do
	source "sxhkdrc.erb"
	owner "dan"
	group "dan"
	mode 0755
end

template "/home/dan/.xinitrc" do
	source "xinitrc.erb"
	owner "dan"
	group "dan"
	mode 0755
end