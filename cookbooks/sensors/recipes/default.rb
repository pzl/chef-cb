package 'lm-sensors' do
	#notifies :run, "execute[sensors-detect]", :immediately
end

#may be dangerous to automate...
execute "sensors-detect" do
	command "sensors-detect"
	action :nothing
end
