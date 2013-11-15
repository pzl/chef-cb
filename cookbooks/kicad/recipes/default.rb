#following http://bazaar.launchpad.net/~kicad-testing-committers/kicad/testing/view/head:/scripts/kicad-install.sh

working_tree = "/home/dan/kicad_sources/"
cmake_opts =  "-DCMAKE_BUILD_TYPE=Release "
cmake_opts += "-DUSE_FP_LIB_TABLE=ON "
cmake_opts += "-DBUILD_GITHUB_PLUGIN=ON " #hey, that sounds interesting

#cmake_opts += "-DKICAD_SCRIPTING=ON -DKICAD_SCRIPTING_MODULES=ON -DKICAD_SCRIPTING_WXPYTHON=ON"


#1) prereqs
package 'bzr' #fetches kicad
package 'bzrtools'  #needed for bzr-patch in `make`. Curious.
package 'build-essential' #we do run `make`, so..
package 'cmake' #building tool
package 'libgl1-mesa-dev' #openGL
#package 'cmake-curses-gui' #why?
#package 'debhelper'
#package 'doxygen' #skippable?
package 'libbz2-dev'
package 'libcairo-dev' #cairo
package 'libglew-dev' #GLEW
package 'libssl-dev' #openSSL actually required. Complains...
package 'libwxgtk2.8-dev' #wxwidgets
package 'python-wxgtk2.8' #wxwidgets

#bzr whoami?

#2) working tree
directory working_tree do
	owner "dan"
	group "dan"
	mode 0755
	action :create
	not_if { ::File.exists? "/usr/local/bin/kicad" }
end

#3) launchpad source
execute "bzr checkout kicad" do
	if Dir.exists? working_tree+"kicad.bzr"
		cwd working_tree+"kicad.bzr"
		command "bzr up"
	else
		cwd working_tree
		command "bzr checkout lp:kicad kicad.bzr"
	end
	#prevents updates
	creates working_tree+"kicad.bzr"
	not_if { ::File.exists? "/usr/local/bin/kicad" }
end

#4) kicad libs
execute "bzr checkout kicad-libs" do
	if Dir.exists? working_tree+"kicad-lib.bzr"
		cwd working_tree+"kicad-lib.bzr"
		command "bzr up"
	else
		cwd working_tree
		command "bzr checkout lp:~kicad-lib-committers/kicad/library kicad-lib.bzr"
	end
	#prevents updates
	creates working_tree+"kicad-lib.bzr"
	not_if { ::File.exists? "/usr/local/bin/kicad" }
end

#5) kicad docs -- skip?

#6) compile source
directory working_tree+"kicad.bzr/build" do
	owner "dan"
	group "dan"
	mode 0755
	action :create
	notifies :run, "execute[cmake kicad]", :immediately
	not_if { ::File.exists? "/usr/local/bin/kicad" }
end

execute "cmake kicad" do
	cwd working_tree+"kicad.bzr/build"
	command "cmake #{cmake_opts} ../"
	action :nothing
	notifies :run, "execute[bzr whoami]", :immediately
end

#yes, somehow THIS is a step to making kicad
execute "bzr whoami" do
	command "bzr whoami 'noname'"
	action :nothing
	notifies :run, "execute[make kicad]", :immediately
end

execute "make kicad" do
	cwd working_tree+"kicad.bzr/build"
	command "make -j"+node["cpu"]["total"].to_s
	action :nothing
end

#7) install
execute "install kicad" do
	cwd working_tree+"kicad.bzr/build"
	command "make install"
	creates "/usr/local/bin/kicad"
	notifies :run, "execute[user config kicad]", :immediately
end

#8) user config
execute "user config kicad" do
	cwd working_tree+"kicad.bzr/build"
	command "make install_user_configuration_files"
	action :nothing
end


#9) libs
directory working_tree+"kicad-lib.bzr/build" do
	owner "dan"
	group "dan"
	mode 0755
	action :create
	notifies :run, "execute[build kicad-lib]", :immediately
	not_if { ::File.exists? "/usr/local/bin/kicad" }
end

execute "build kicad-lib" do
	cwd working_tree+"kicad-lib.bzr/build"
	command <<-EOH
		cmake ../
		make install
	EOH
	action :nothing
end