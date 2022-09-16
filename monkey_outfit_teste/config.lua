Config = {}

Config.Admin = function()
    local source = source
	local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id,"Admin")    
end