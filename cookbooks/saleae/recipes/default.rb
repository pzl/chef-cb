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
		mv "Logic 1.1.15 (#{arch}-bit)" /home/dan/bin/
		udevadm control --reload-rules
		udevadm trigger
	EOH
	#need bin/logic
	#permissions nightmare
	action :nothing
end

#wget "http://downloads.saleae.com/Logic%201.1.15%20($ARCH-bit).zip"; unzip "Logic 1.1.15 ($ARCH-bit).zip"; rm -rf "Logic 1.1.15 ($ARCH-bit).zip"; mv "Logic 1.1.15 ($ARCH-bit)" ~/bin/;
#sudo cp "~/bin/Logic 1.1.15 ($ARCH-bit)/Drivers/99-SaleaeLogic.rules" /etc/udev/rules.d/;
#sudo udevadm control --reload-rules; sudo udevadm trigger;