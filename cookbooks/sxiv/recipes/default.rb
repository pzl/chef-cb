package 'libx11-dev'
package 'libimlib2-dev'
package 'libgif-dev'

git "#{Chef::Config[:file_cache_path]}/sxiv" do
	repository "https://github.com/muennich/sxiv.git"
	action :checkout
	notifies :run, "execute[install sxiv]", :immediately
end

execute "install sxiv" do
	cwd "#{Chef::Config[:file_cache_path]}/sxiv"
	command <<-EOH
		make
		make install
	EOH
	action :nothing
end
