#determine arch
if node['kernel']['machine'] == 'x86_64'
	arch = 64
else
	arch = 32
end

remote_file "#{Chef::Config[:file_cache_path]}/Logic.zip" do
	source "http://downloads.saleae.com/Logic%201.1.15%20(#{arch}-bit).zip"
	backup false
	notifies :run, "execute[install Logic]", :immediately
end

execute "install Logic" do
	cwd Chef::Config[:file_cache_path]
	command <<-EOH
		unzip Logic.zip
		rm -rf Logic.zip
		cp "Logic 1.1.15 (#{arch}-bit)/Drivers/99-SaleaeLogic.rules" /etc/udev/rules.d/
		mv "Logic 1.1.15 (#{arch}-bit)" #{node[:user][:home]}/bin/
		chown -R #{node[:user][:name]} "#{node[:user][:home]}/bin/Logic 1.1.15 (#{arch}-bit)"
		udevadm control --reload-rules
		udevadm trigger
	EOH
	creates "#{node[:user][:home]}/bin/Logic 1.1.15 (#{arch}-bit)/Logic"
end

template "#{node[:user][:home]}/bin/logic" do
	source "logic.erb"
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
	backup false
	variables  :dir => "Logic\\ 1.1.15\\ \\(#{arch}-bit\\)" 
	action :create_if_missing
end