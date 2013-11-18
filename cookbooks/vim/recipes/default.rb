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

#install pathogen
directory "/home/dan/.vim/autoload" do
	owner "dan"
	group "dan"
	mode 0755
	recursive true
end
directory "/home/dan/.vim/bundle" do
	owner "dan"
	group "dan"
	mode 0755
	recursive true
end
remote_file "/home/dan/.vim/autoload/pathogen.vim" do
	source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
	owner "dan"
	group "dan"
	mode 0644
end


#install airline
git "/home/dan/.vim/bundle/vim-airline" do
	repository "https://github.com/bling/vim-airline"
	action :sync
	user "dan"
	group "dan"
end
#powerline fonts
remote_file "/home/dan/.fonts/PowerlineSymbols.otf" do
	source "https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf"
	owner "dan"
	group "dan"
	mode 0644
	notifies :run, "execute[font cache]", :immediately
end
remote_file "/home/dan/.fontconfig/10-powerline-symbols.conf" do
	source "https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf"
	owner "dan"
	group "dan"
	mode 0644
end
execute "font cache" do
	cwd "/home/dan"
	command "fc-cache -vf .fonts"
	action :nothing
end

#vim fugitive for airline-git statusbar
git "/home/dan/.vim/bundle/vim-fugitive" do
	repository "https://github.com/tpope/vim-fugitive.git"
	action :sync
	user "dan"
	group "dan"
end

#vim gitgutter
git "/home/dan/.vim/bundle/vim-gitgutter" do
	repository "https://github.com/airblade/vim-gitgutter.git"
	action :sync
	user "dan"
	group "dan"
end

#bufferline
git "/home/dan/.vim/bundle/vim-bufferline" do
	repository "https://github.com/bling/vim-bufferline.git"
	action :sync
	user "dan"
	group "dan"
end