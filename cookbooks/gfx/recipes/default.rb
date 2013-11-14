smxi_src = "http://smxi.org/smxi.zip"
smxi_path = "/usr/local/"


#detect AMD vs nvidia
execute "graphics detection" do
	command "lspci | grep VGA"
	action :nothing
end

#if nvidia
#package 'module-assistant'
#package 'nvidia-kernel-common'
execute "ma nvidia-kernel" do
	command "m-a auto-install nvidia-kernel-common"
	action :nothing
end
#package "nvidia-glx"
#package "nvidia-xconfig"
#package "nvidia-settings"
execute "nvidia-xconfig" do
	command "nvidia-xconfig"
	action :nothing
end


#check out: mesa-utils, libvdpau-dev


#if AMD: smxi
package "unzip"
package "dkms"
package "linux-headers-$(uname -r)"
remote_file smxi_path+"smxi.zip" do
	source smxi_src
	owner "root"
	group "root"
	mode 0644
	backup 0
	action :nothing
end
execute "unzip smxi" do
	cwd smxi_path
	command <<-EOH
		unzip smxi.zip
		rm -rf smxi.zip
	EOH
	action :nothing
end