#stops apt from indexing a thousand en_US packages, half of which fail
cookbook_file "/etc/apt/apt.conf.d/99translations" do
	mode 0644
	owner "root"
	group "root"
	source "99translations"
end