# Cookbook Name: heroku
# Recipe: default

#todo: x-platform
execute "install heroku toolbelt" do
  command "wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | bash"
  action :run
  not_if { ::File.exists?("/usr/bin/heroku") }
end