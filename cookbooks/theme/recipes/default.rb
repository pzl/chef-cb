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
#compton
#background

#other RCs