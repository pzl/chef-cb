#.conky
remote_directory "/home/dan/.conky" do
	files_group "dan"
	files_owner "dan"
	files_mode 0600
	mode 0755
	owner "dan"
	group "dan"
	files_backup 0
	source ".conky"
end

file "/home/dan/.conky/sensors.sh" do
	mode 0700
end

#cron
cookbook_file "/etc/cron.d/ip.cron" do
	source "ip.cron"
	mode 0644
	owner "root"
	group "root"
end