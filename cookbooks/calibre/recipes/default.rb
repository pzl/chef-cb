#calibre
#todo: move to attributes?
fp = "#{Chef::Config['file_cache_path']}/calibre_install"
calibre_path = "/usr/local"

remote_file fp do
	source "http://status.calibre-ebook.com/linux_installer"
	mode 0755
	not_if { ::File.exists?("/usr/bin/calibre") }
	notifies :run, "execute[python-calibre]", :immediately
end

execute "python-calibre" do
	command "python #{fp}"
	environment ({ "CALIBRE_INSTALL_DIR" => calibre_path, "PYTHONIOENCODING"=>'UTF-8' })
	action :nothing
end
