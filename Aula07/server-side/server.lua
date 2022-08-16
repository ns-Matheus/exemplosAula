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
Tunnel.bindInterface("Aula07", cRP)
vSERVER = Tunnel.getInterface("Aula07")


-- Registra um Evento no server que tanto o Client como o próprio Servidor pode chamar
RegisterServerEvent("aula07:removeblip") 
AddEventHandler("aula07:removeblip",function(qtd, nome_item)  

    local source = source
    local user_id = vRP.getUserId(source)

    if user_id then
        TriggerClientEvent("Notify",source,"verde","Você apertou o botao ~g~E.", 5000) -- Trigger que o Client chama
    end
end)