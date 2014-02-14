execute "install node" do
	cwd "/tmp"
	command <<-EOH
		NODEV=$(curl -s http://nodejs.org/dist/latest/SHASUMS.txt | head -n 1 | sed 's/.*node-v\\([0-9]\\+\\.[0-9]\\+\\.[0-9]\\+\\).*/\\1/i')
		wget http://nodejs.org/dist/latest/node-v$NODEV.tar.gz
		tar -xzf node-v$NODEV.tar.gz
		cd node-v$NODEV
		./configure
		make -j#{node[:cpu][:total]}
		make install
		cd ..
		rm -rf node-v$NODEV node-v$NODEV.tar.gz
	EOH
	creates "/usr/local/bin/node"
end