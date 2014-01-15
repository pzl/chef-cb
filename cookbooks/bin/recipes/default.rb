scripts = [
	"bkup",
	"colors",
	"colors256",
	"cw",
	"diam",
	"gdate",
	"hipster",
	"mkgif",
	"invade",
	"lamp",
	"pipes",
	"rain",
	"ruler",
	"sauber",
	"webcam"
]

scripts.each do |file|
	template "#{node[:user][:home]}/bin/#{file}" do
		source file
		mode 0755
		owner node[:user][:name]
		group node[:user][:name]	
	end
end