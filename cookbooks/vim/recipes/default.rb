package 'vim'

cookbook_file "/home/dan/.vimrc" do
	source ".vimrc"
	mode 0644
	owner "dan"
	group "dan"
end

cookbook_file "/root/.vimrc" do
	source ".vimrc"
	mode 0644
	owner "root"
	group "root"
end