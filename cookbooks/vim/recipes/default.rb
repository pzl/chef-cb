package 'vim'

cookbook_file "#{node[:user][:home]}/.vimrc" do
	source ".vimrc"
	mode 0644
	owner node[:user][:name]
	group node[:user][:name]
end

cookbook_file "/root/.vimrc" do
	source ".vimrc"
	mode 0644
	owner "root"
	group "root"
end

#install pathogen
directory "#{node[:user][:home]}/.vim" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	action :create
end

directory "#{node[:user][:home]}/.vim/autoload" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	recursive true
end
directory "#{node[:user][:home]}/.vim/bundle" do
	owner node[:user][:name]
	group node[:user][:name]
	mode 0755
	recursive true
end
remote_file "#{node[:user][:home]}/.vim/autoload/pathogen.vim" do
	source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end


#install airline
git "#{node[:user][:home]}/.vim/bundle/vim-airline" do
	repository "https://github.com/bling/vim-airline"
	action :sync
	user node[:user][:name]
	group node[:user][:name]
end
#powerline fonts
remote_file "#{node[:user][:home]}/.fonts/PowerlineSymbols.otf" do
	source "https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	notifies :run, "execute[font cache]", :immediately
end
remote_file "#{node[:user][:home]}/.fonts/Inconsolata for Powerline.otf" do
	source "https://github.com/Lokaltog/powerline-fonts/raw/master/Inconsolata%20for%20Powerline.otf"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
	notifies :run, "execute[font cache]", :immediately
end
remote_file "#{node[:user][:home]}/.fontconfig/10-powerline-symbols.conf" do
	source "https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf"
	owner node[:user][:name]
	group node[:user][:name]
	mode 0644
end
execute "font cache" do
	cwd "#{node[:user][:home]}"
	command "fc-cache -vf .fonts"
	action :nothing
end

#vim fugitive for airline-git statusbar
git "#{node[:user][:home]}/.vim/bundle/vim-fugitive" do
	repository "https://github.com/tpope/vim-fugitive.git"
	action :sync
	user node[:user][:name]
	group node[:user][:name]
end

#vim easymotion
git "#{node[:user][:home]}/.vim/bundle/vim-easymotion" do
	repository "https://github.com/Lokaltog/vim-easymotion.git"
	action :sync
	user node[:user][:name]
	group node[:user][:name]
end

#bufferline
#git "#{node[:user][:home]}/.vim/bundle/vim-bufferline" do
#	repository "https://github.com/bling/vim-bufferline.git"
#	action :sync
#	user node[:user][:name]
#	group node[:user][:name]
#end

#