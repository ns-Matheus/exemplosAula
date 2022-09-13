ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server.lua"
}

files{
	"web-side/*",
	"web-side/assets/*",
}