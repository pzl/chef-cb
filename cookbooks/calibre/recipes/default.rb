#calibre
#todo: move to attributes?
fp = "#{Chef::Config['file_cache_path']}/calibre.tar.bz2"
calibre_path = "/usr/local"
url = "http://status.calibre-ebook.com/dist/linux32"
if node['kernel']['machine'] == 'x86_64'
	url.gsub! '32', '64'
end


#they insist on just having the craziest download method.
#remote_file fp do
#	source "http://status.calibre-ebook.com/linux_installer"
#	mode 0755
#	not_if { ::File.exists?("/usr/bin/calibre") }
#	notifies :run, "execute[python-calibre]", :immediately
#end

#execute "python-calibre" do
#	command "python #{fp}"
#	environment ({ "CALIBRE_INSTALL_DIR" => calibre_path, "PYTHONIOENCODING"=>'UTF-8' })
#	action :nothing
#end

remote_file fp do
	source url
	mode 0644
	not if { ::File.exists? "/usr/bin/calibre" }
	notifies :run, "execute[install calibre]", :immediately
end

execute "install calibre" do
	cwd Chef::Config['file_cache_path']
	command <<-EOH
		tar -xjf calibre.tar.bz2 -C #{calibre_path}
		rm -rf calibre.tar.bz2
		#{calibre_path}/calibre/calibre_postinstall
	EOH
	creates "/usr/bin/calibre"
end