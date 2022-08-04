-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")


-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("Aula06", cRP)
vSERVER = Tunnel.getInterface("Aula06")


-- Registra um Evento no server que tanto o Client como o próprio Servidor pode chamar
RegisterServerEvent("aula06:item_recebido") 
AddEventHandler("aula06:item_recebido",function(qtd, nome_item)  

    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        vRP.giveInventoryItem(user_id,nome_item,qtd,true)
        TriggerClientEvent("Notify",source,"verde","Você recebeu o pagamento.", 5000) -- Trigger que o Clientchama
    end
end)



TriggeEvent("aula06:pagamento", 100, "dollars", 5000) --Trigger que o próprio Server chama