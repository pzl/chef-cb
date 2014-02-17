#get
sublime_2_url = "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2"
sublime_3_url = "http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_3059_x64.tar.bz2"
sublime_3_deb = "http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3047_amd64.deb"

execute "sublime-text2" do
	cwd "#{node[:user][:home]}/bin"
	command <<-EOH
		wget -O sub.tar.bz2 #{sublime_2_url}
		tar -xjf sub.tar.bz2
		rm -rf sub.tar.bz2
		cd "Sublime Text 2"
		cp sublime_text sublime_text.bak
		xxd -p sublime_text.bak | sed 's/433333423032/433332423032/' | xxd -r -p >sublime_text
		cd ..
		chown -R #{node[:user][:name]} "Sublime Text 2"
		"Sublime Text 2/sublime_text" &
		sleep 1s && killall sublime_text
		mv /root/.config/sublime-text-2 #{node[:user][:home]}/.config/sublime-text-2
		chown -R #{node[:user][:name]} #{node[:user][:home]}/.config/sublime-text-2
	EOH
	creates "#{node[:user][:home]}/bin/Sublime\ Text\ 2/sublime_text"
end


execute "sublime-text3" do
	cwd "#{node[:user][:home]}/bin"
	command <<-EOH
		wget -O sub3.tar.bz2 #{sublime_3_url}
		tar -xjf sub3.tar.bz2
		rm -rf sub3.tar.bz2
		cd sublime_text_3
		cp sublime_text sublime_text.bak
		xxd -p sublime_text.bak | sed 's/433333423032/433332423032/' | xxd -r -p >sublime_text
		cd ..
		chown -R #{node[:user][:name]} "sublime_text_3"
		"sublime_text_3/sublime_text" &
		sleep 1s && killall sublime_text
		mv /root/.config/sublime-text-3 #{node[:user][:home]}/.config/sublime-text-3
		chown -R #{node[:user][:name]} #{node[:user][:home]}/.config/sublime-text-3
	EOH
	creates "#{node[:user][:home]}/bin/sublime_text_3/sublime_text"
end


template "#{node[:user][:home]}/bin/sub" do
	source "sub"
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
	variables ({
		:path => "#{node[:user][:home]}/bin",
		:dir => "Sublime Text 2"
	})
end

template "#{node[:user][:home]}/bin/sub3" do
	source "sub"
	mode 0755
	owner node[:user][:name]
	group node[:user][:name]
	variables ({
		:path => "#{node[:user][:home]}/bin",
		:dir => "sublime_text_3"
	})
end

#we own a single-user license (available upon request!)
#but publishing our license to github is a no-no
#can't always depend on automated private things
template "#{node[:user][:home]}/.config/sublime-text-2/Settings/License.sublime_license" do
	source "sublime_license"
	mode 0600
	owner node[:user][:name]
	group node[:user][:name]
	action :create_if_missing
end

#@todo
#packages -- that would be a doozy
#http://stackoverflow.com/questions/19529999/add-package-control-in-sublime-text-3-through-the-command-line
#configs, workspaces, etc