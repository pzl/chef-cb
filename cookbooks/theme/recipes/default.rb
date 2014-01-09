walls = [
	"6WDf03g.jpg",
	"AcRfpIM.jpg",
	"FHSqNyg.jpg",
	"G8QmxXV.jpg",
	"K3qPeqO.jpg",
	"WjDm2Bv.jpg",
	"c74bh.jpg",
	"e7XpEQu.jpg",
	"hGAfhkL.jpg",
	"jLbCzTk.jpg",
	"lFsPism.jpg",
	"r6dgeuO.jpg",
	"yXOMnFM.jpg",
	"PmgNXdI.jpg",
	"dQL1Ea7.jpg",
	"lqCOd8m.jpg"
]

#flatstudio
execute "flatstudio" do
	cwd Chef::Config['file_cache_path']
	command <<-EOH
		wget http://gnome-look.org/CONTENT/content-files/154296-FlatStudio-1.03.tar.gz
		tar -xzf 154296-FlatStudio-1.03.tar.gz
		rm -rf 154296-FlatStudio-1.03.tar.gz
		mv FlatStudio /usr/share/themes/
		mv FlatStudioDark /usr/share/themes/
		mv FlatStudioGray /usr/share/themes/
		mv FlatStudioLight /usr/share/themes/
	EOH
	creates "/usr/share/themes/FlatStudioDark/readme.txt"
end

template "#{node[:user][:home]}/.config/gtk-3.0/settings.ini" do
	source "gtk-3-settings"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

template "#{node[:user][:home]}/.gtkrc-2.0" do
	source ".gtkrc-2.0"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	variables({ "home_dir" => node[:user][:home] })
end
template "/root/.gtkrc-2.0" do
	source ".gtkrc-2.0"
	owner "root"
	group "root"
	mode 0644
end

template "#{node[:user][:home]}/.gtk-bookmarks" do
	source ".gtk-bookmarks"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	variables({ "home_dir" => node[:user][:home] })
end


#thunar
template "#{node[:user][:home]}/.config/Thunar/thunarrc" do
	source "thunarrc"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

template "#{node[:user][:home]}/.config/Thunar/uca.xml" do
	source "uca.xml"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

#openbox
template "#{node[:user][:home]}/.config/openbox/menu.xml" do
	source "menu.xml"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

template "#{node[:user][:home]}/.config/openbox/rc.xml" do
	source "rc.xml"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

#wallpapers
template "#{node[:user][:home]}/.config/nitrogen/bg-saved.cfg" do
	source "bg-saved.cfg"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	variables({ "home_dir" => node[:user][:home] })
end

template "#{node[:user][:home]}/.config/nitrogen/nitrogen.cfg" do
	source "nitrogen.cfg"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end


#wallpapers
walls.each do |wall|
	cookbook_file "#{node[:user][:home]}/images/wallpapers/#{wall}" do
		source wall
		owner node[:user][:name]
		group node[:user][:name]
		mode 0644	end
end



#tint2
template "#{node[:user][:home]}/.config/tint2/tint2rc" do
	source "tint2rc"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	#notifies :run, "execute[tint2restart]", :immediately
end
#bug: still runs as root :[
#execute "tint2restart" do
#	command "tint2restart"
#	user node[:user][:name]
#	action :nothing
#end


#terminator config
template "#{node[:user][:home]}/.config/terminator/config" do
	source "terminator-config"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

#Xresource config
template "#{node[:user][:home]}/.config/.Xresources" do
	source ".Xresources"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

#rxvt color command
template "#{node[:user][:home]}/.config/colorconfig" do
	source "colorconfig"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end

template "#{node[:user][:home]}/bin/sc" do
	source "sc"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0700
	variables(
		:userhome => node[:user][:home]
	)
end

file "#{node[:user][:home]}/.config/color" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0600
	action :create_if_missing
end


#compton -- disable shadows
template "#{node[:user][:home]}/.config/compton.conf" do
	source "compton.conf"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	notifies :run, 'execute[compton]', :immediately
end

execute "compton" do
	command "killall compton"
	action :nothing
end

#other RCs
