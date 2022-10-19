game 'gta5'
fx_version 'adamant'

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

ui_page "web-side/index.html"

files {
	"web-side/css/*",
	"web-side/fonts/*",
	"web-side/images/*",
	"web-side/script/*",
	"web-side/pages/*",
	"web-side/sounds/*",
	"web-side/index.html"
}