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

git "#{Chef::Config[:file_cache_path]}/xwinfo" do
	repository "https://github.com/baskerville/xwinfo.git"
	action :checkout
	notifies :run, "execute[install xwinfo]", :immediately
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

execute "install xwinfo" do
	cwd "#{Chef::Config[:file_cache_path]}/xwinfo"
	command <<-EOH
		make
		make install
	EOH
	action :nothing
end

execute "bspwm create_frame" do
	cwd "#{Chef::Config[:file_cache_path]}/bspwm"
	command <<-EOH
		gcc -lxcb-icccm -lxcb -o create_frame contrib/create_frame.c
		cp create_frame /usr/local/bin
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
			/^\#\s*(login_cmd\s+.*)(\/bin\/sh\s+\-)(.*xinitrc\s+%session)/i,
			'\1/bin/bash -login\3'
		)
		#add bspwm to session list
		f.gsub!(
			/^sessions\s+openbox-session/i,
			'\0,bspwm'
		)
		File.open('/etc/slim.conf','w') { |file| file.puts f }
		#f.write_file
	end
	not_if { ::File.exists? "#{node[:user][:home]}/.config/bspwm/bspwmrc"}
end

directory "#{node[:user][:home]}/.config/bspwm" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end

directory "#{node[:user][:home]}/.config/sxhkd" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end

template "#{node[:user][:home]}/.config/bspwm/bspwmrc" do
	source "bspwmrc.erb"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end

template "#{node[:user][:home]}/.config/sxhkd/sxhkdrc" do
	source "sxhkdrc.erb"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end

template "#{node[:user][:home]}/.xinitrc" do
	source "xinitrc.erb"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
end