fx_version "bodacious"
game "gta5"

ui_page "nui/index.html"

files {
	"nui/*",
	"nui/**/*",
	"nui/**/**/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client-side/*",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server-side/*",
}