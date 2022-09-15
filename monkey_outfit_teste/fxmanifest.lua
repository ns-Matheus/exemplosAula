game 'gta5'
fx_version 'adamant'
ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client-side/*.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server-side/server.lua"
}

files{
	"web-side/*",
	"web-side/assets/*",
}