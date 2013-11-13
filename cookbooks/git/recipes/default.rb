package 'git-core'

cookbook_file "/home/dan/.gitconfig" do
	source ".gitconfig"
	mode 0600
	owner "dan"
	group "dan"
end

cookbook_file "/home/dan/.gitcompletion.sh" do
	source ".gitcompletion.sh"
	mode 0600
	owner "dan"
	group "dan"
end

#private keys?