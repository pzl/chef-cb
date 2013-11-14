#.conky

location = "/home/dan/"
dirs = [
	".conky",
	".conky/lua",
	".conky/output",
	".conky/scripts"
]
files = [
	".conky/conky-bar",
	".conky/conky-bg",
	".conky/conky-click",
	".conky/conky-lua",
	".conky/dzen-demo",
	".conky/lua/circ.lua",
	".conky/lua/clicky.lua",
	".conky/lua/demo.lua",
	".conky/lua/mail.lua",
	".conky/lua/start.lua",
	".conky/output/clicker",
	".conky/output/ip",
	".conky/output/sensors.txt",
]

dirs.each do |dir|
	directory location+dir do
		owner "dan"
		group "dan"
		mode 0755
	end
end

files.each do |f|
	template location+f do
		source f
		owner "dan"
		group "dan"
		mode 0600
		backup false
		#variables
			#nvidia vs amd
			#cpu cores
			#wlan vs eth?
	end
end


#remote_directory "/home/dan/.conky/" do
#	path "/home/dan/.conky"
#	files_group "dan"
#	files_owner "dan"
#	files_mode 0600
#	mode 0755
#	owner "dan"
#	group "dan"
#	files_backup 0
#	source ".conky"
#	action :create_if_missing
#end

template location+".conky/scripts/sensors.sh" do
	source ".conky/scripts/sensors.sh"
	mode 0700
	owner "dan"
	group "dan"
end

#cron
template "/etc/cron.d/ip.cron" do
	source "ip.cron"
	mode 0644
	owner "root"
	group "root"
end