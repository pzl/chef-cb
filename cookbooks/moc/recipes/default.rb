package 'moc'
remote_directory "#{node[:user][:home]}/.moc" do
	source ".moc"
	files_owner node[:user][:name]
	files_group node[:user][:name]
	files_backup 0
	files_mode 0600
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
end