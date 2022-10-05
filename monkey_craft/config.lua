Config = {}

Config.login = "vrpex" -- login de acesso
Config.senha = "123" -- senha de acesso

Config.permissaoParaCriar = 'Admin'


Config.tempoCraftar = 5000

Config.multiplicadorTempoCraft = 1000

Config.notificar = function(msg)
    local source = source
    TriggerClientEvent("Notify", source, "amarelo", msg, 5000)
end

Config.darItem = function(user_id, nome, quantidade)
    vRP.giveInventoryItem(user_id, nome, parseInt(quantidade), true)
end

Config.removerItem = function(user_id, nome, quantidade)
    vRP.removeInventoryItem(user_id, nome, quantidade, true)
end

Config.pegarQuantidade = function(user_id, nome)
    return vRP.getInventoryItemAmount(user_id, nome)
end

Config.getItens = function()
    local itens = {}
    for k,v in pairs(vRP.getItens()) do
        table.insert(itens, k)
    end
    return itens
end

Config.getNomeVitrine = function(index)
    for k,v in pairs(vRP.getItens()) do
        if index == k then
            return v.name
        end
    end
    return "Desconhecido"
end