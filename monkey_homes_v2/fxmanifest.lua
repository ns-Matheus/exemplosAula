fx_version 'adamant'
game 'gta5'

ui_page "nui/index.html"

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

files {
	"nui/css/*",
	"nui/fonts/*",
	"nui/images/*",
	"nui/script/*",
	"nui/pages/*",
	"nui/sounds/*",
	"nui/index.html"
}