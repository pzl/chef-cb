package 'git-core'

cookbook_file "#{node[:user][:home]}/.gitconfig" do
	source ".gitconfig"
	mode 0600
	owner node[:user][:name]
	group node[:user][:name]
end

cookbook_file "#{node[:user][:home]}/.gitcompletion.sh" do
	source ".gitcompletion.sh"
	mode 0600
	owner node[:user][:name]
	group node[:user][:name]
end

#private keys?