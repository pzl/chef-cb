#flatstudio


cookbook_file "/home/dan/.config/gtk-3.0/settings.ini" do
	source "gtk-3-settings"
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

#compton
#background

#other RCs