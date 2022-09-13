local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("monkey_rotanortesul",emP)


local habilitado = false

RegisterServerEvent("monkey:modulos")
AddEventHandler("monkey:modulos",function()
	habilitado = true
end) 

function emP.isValido()
	return habilitado	
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment(item,qtd, police, x,y,z)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.computeInvWeight(user_id) + vRP.itemWeightList(item) * qtd <= vRP.getBackpack(user_id) then
			
			vRP.giveInventoryItem(user_id,item,qtd,true)

			local chance = math.random(1,10)

			if police ~= 0 and police >= chance then 
				local copAmount = vRP.numPermission(Config.perm_police)
				for k,v in pairs(copAmount) do
					async(function()
						TriggerClientEvent("NotifyPush",v,{ time = os.date("%H:%M:%S - %d/%m/%Y"), code = 20, title = "Denúncia de Rota ilegal", x = x, y = y, z = z, rgba = {41,76,119} })
					end)
				end
			end
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

function emP.checkItem2(item,qtd)
	local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
		if vRP.tryGetInventoryItem(user_id, item, qtd, true) then
			return true
		else
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