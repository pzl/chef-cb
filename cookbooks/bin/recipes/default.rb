scripts = [
	"bkup",
	"colors",
	"diam",
	"gdate",
	"hipster",
	"invade",
	"lamp",
	"pipes",
	"rain",
	"ruler",
	"sauber"
]

scripts.each do |file|
	template "#{node[:user][:home]}/bin/#{file}" do
		source file
		mode 0755
		owner node[:user][:name]
		group node [:user][:name]	
	end
end