package 'python-gtk2'
package 'python-serial'
package 'python-libxml2'

execute "install chirp" do
	cwd "/tmp"
	command <<-EOH
		CHRPV=$(curl -s http://trac.chirp.danplanet.com/chirp_daily/LATEST/SHA1SUM | grep 'daily.*tar' | cut -d ' ' -f 3 | cut -d '.' -f 1)
		wget http://trac.chirp.danplanet.com/chirp_daily/LATEST/$CHRPV.tar.gz
		tar -xzf $CHRPV.tar.gz
		cd $CHRPV
		python setup.py install
		cd ..
		rm -rf $CHRPV $CHRPV.tar.gz
	EOH
	creates "/usr/local/bin/chirpw"
end