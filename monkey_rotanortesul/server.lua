local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("monkey_rotanortesul",emP)


-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(item,qtd)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.computeInvWeight(user_id) + vRP.itemWeightList(item) * qtd <= vRP.getBackpack(user_id) then
			vRP.giveInventoryItem(user_id,item,qtd,true)
		else
			TriggerClientEvent("Notify",source,"negado","Não há espaço na mochila.",5000)
			return false
		end	
	end
	return true
end

function emP.checkItem(item,qtd)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.tryGetInventoryItem(user_id, item, qtd, true) then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa do "..vRP.itemNameList(item),5000)
			return false
		end	
	end
	return false
end

function emP.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end