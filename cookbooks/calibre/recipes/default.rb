#calibre
fp = "#{Chef::Config['file_cache_path']}/calibre_install"
calibre_path = "/usr/local"

remote_file fp do
	source "http://status.calibre-ebook.com/linux_installer"
	mode 0755
	action :create_if_missing
	not_if { ::File.exists?(calibre_path+"/calibre") }
	notifies :run, "execute[python-calibre]"
end

execute "python-calibre" do
	command "CALIBRE_INSTALL_DIR=#{calibre_path} python #{fp}"
	action :nothing
end
