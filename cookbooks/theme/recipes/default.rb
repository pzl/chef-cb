#flatstudio


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