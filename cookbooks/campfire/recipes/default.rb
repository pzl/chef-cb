package 'irssi'
package 'ruby-1.9.3'
gem_package 'camper_van'
package 'libssl-dev'

#maybe find a way to do .config/irssi/config?
template '/home/dan/.irssi/config' do
	source 'irssi.config.erb'
	mode 0755
	owner "dan"
	group "dan"
	backup false
end