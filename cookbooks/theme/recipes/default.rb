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

cookbook_file "/home/dan/.config/gtk-3.0/settings.ini" do
	source "gtk-3-settings"
	owner "dan"
	group "dan"
	mode 0644
end

cookbook_file "/home/dan/.gtkrc-2.0" do
	source ".gtkrc-2.0"
	owner "dan"
	group "dan"
	mode 0644
end
cookbook_file "/root/.gtkrc-2.0" do
	source ".gtkrc-2.0"
	owner "root"
	group "root"
	mode 0644
end

cookbook_file "/home/dan/.gtk-bookmarks" do
	source ".gtk-bookmarks"
	owner "dan"
	group "dan"
	mode 0644
end


#thunar
cookbook_file "/home/dan/.config/Thunar/thunarrc" do
	source "thunarrc"
	owner "dan"
	group "dan"
	mode 0644
end

cookbook_file "/home/dan/.config/Thunar/uca.xml" do
	source "uca.xml"
	owner "dan"
	group "dan"
	mode 0644
end

#openbox
cookbook_file "/home/dan/.config/openbox/menu.xml" do
	source "menu.xml"
	owner "dan"
	group "dan"
	mode 0644
end

cookbook_file "/home/dan/.config/openbox/rc.xml" do
	source "rc.xml"
	owner "dan"
	group "dan"
	mode 0644
end

#wallpapers
cookbook_file "/home/dan/.config/nitrogen/bg-saved.cfg" do
	source "bg-saved.cfg"
	owner "dan"
	group "dan"
	mode 0644
end

cookbook_file "/home/dan/.config/nitrogen/nitrogen.cfg" do
	source "nitrogen.cfg"
	owner "dan"
	group "dan"
	mode 0644
end

cookbook_file "/home/dan/images/wallpapers/6WDf03g.jpg" do
	source "6WDf03g.jpg"
	owner "dan"
	group "dan"
	mode 0644
end


#tint2
cookbook_file "/home/dan/.config/tint2/tint2rc" do
	source "tint2rc"
	owner "dan"
	group "dan"
	mode 0644
	#notifies :run, "execute[tint2restart]", :immediately
end
#bug: still runs as root :[
#execute "tint2restart" do
#	command "tint2restart"
#	user "dan"
#	action :nothing
#end


#terminator config
cookbook_file "/home/dan/.config/terminator/config" do
	source "terminator-config"
	owner "dan"
	group "dan"
	mode 0644
end

#compton -- disable shadows
cookbook_file "/home/dan/.config/compton.conf" do
	source "compton.conf"
	owner "dan"
	group "dan"
	mode 0644
	notifies :run, 'execute[compton]', :immediately
end

execute "compton" do
	command "killall compton"
	action :nothing
end

#other RCs
