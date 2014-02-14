package 'libx11-dev'
package 'libimlib2-dev'
package 'libgif-dev'

git "#{Chef::Config[:file_cache_path]}/sxiv" do
	repository "https://github.com/muennich/sxiv.git"
	action :checkout
	notifies :run, "execute[install sxiv]", :immediately
	not_if { ::File.exists? "/usr/local/bin/sxiv" }
end

execute "install sxiv" do
	cwd "#{Chef::Config[:file_cache_path]}/sxiv"
	command <<-EOH
		sed -r --in-place 's/(GIF_LOOP\s+\=\s*)0/\\11/' config.def.h
		make -j#{node[:cpu][:total]}
		make install
	EOH
	action :nothing
	creates "/usr/local/bin/sxiv"
end
