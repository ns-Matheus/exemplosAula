local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local autorizado = true

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface(GetCurrentResourceName(), cnVRP)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())

vRP.prepare('monkey_onibus/get_monkey_onibus','SELECT id, x, y, z, idDono, preco, valorCaixa, xp, nivel, porcentagemGanho, metaXp FROM monkey_onibus')
vRP.prepare('monkey_onibus/get_by_id','SELECT id, x, y, z, idDono, preco, valorCaixa, xp, nivel, porcentagemGanho, metaXp FROM monkey_onibus where id = @id')
vRP.prepare('monkey_onibus/set_id_dono','UPDATE monkey_onibus SET idDono = @user_id WHERE id = @id')
vRP.prepare('monkey_onibus/att_xp','UPDATE monkey_onibus SET xp = @xp WHERE id = @id')
vRP.prepare('monkey_onibus/att_meta_xp','UPDATE monkey_onibus SET metaXp = @meta_xp WHERE id = @id')
vRP.prepare('monkey_onibus/att_nivel','UPDATE monkey_onibus SET nivel = @nivel WHERE id = @id')
vRP.prepare('monkey_onibus/add_valor_caixa','UPDATE monkey_onibus SET valorCaixa = valorCaixa + @valor WHERE id = @id')
vRP.prepare('monkey_onibus/rem_valor_caixa','UPDATE monkey_onibus SET valorCaixa = valorCaixa - @valor WHERE id = @id')
vRP.prepare('monkey_onibus/att_porcentagem','UPDATE monkey_onibus SET porcentagemGanho = @porcentagemGanho WHERE id = @id')

local locs = nil

function cnVRP.getLocs(valor)
    if locs == nil then
        locs = vRP.query("monkey_onibus/get_monkey_onibus")
    end

    return locs
end

function cnVRP.getLocId(idLoc)
    local source = source
    local user_id = vRP.getUserId(source)

    local infoPlayer = vRP.getInformation(user_id)
    local name = infoPlayer[1].name.." "..infoPlayer[1].name2

    local rows = vRP.query("monkey_onibus/get_by_id", {id = idLoc})
    rows[1].idPlayer = user_id
    rows[1].namePlayer = name

    return rows
end

function cnVRP.payment(valor, idLoc)
    local source = source
    local user_id = vRP.getUserId(source)
    
    local loc = vRP.query("monkey_onibus/get_by_id", {id = idLoc})

    if loc[1] ~= nil and loc[1].idDono then
        local ganho_empresa = loc[1].porcentagemGanho
        local ganho_motorista = 100 - loc[1].porcentagemGanho

        if loc[1].xp + valor > loc[1].metaXp then
            vRP.execute('monkey_onibus/att_nivel', { id = idLoc, nivel = loc[1].nivel + 1 })
            vRP.execute('monkey_onibus/att_xp', { id = idLoc, xp = 0 })
            vRP.execute('monkey_onibus/att_meta_xp', { id = idLoc, meta_xp = loc[1].metaXp * 2 })
        else
            vRP.execute('monkey_onibus/att_xp', { id = idLoc, xp = loc[1].xp + valor })
        end

        vRP.execute('monkey_onibus/add_valor_caixa', { id = idLoc, valor = (valor * (ganho_empresa/100) * (1 + loc[1].nivel/10)) })
        
        vRP.giveInventoryItem(user_id, "dollars", (valor * (ganho_motorista/100)),true)
    else
        vRP.giveInventoryItem(user_id, "dollars", valor,true)
    end
end

function cnVRP.buy(id)
    local source = source
    local user_id = vRP.getUserId(source)

    local loc = vRP.query("monkey_onibus/get_by_id", {id = id})

    if vRP.paymentBank(user_id,loc[1].preco) then
        vRP.execute("monkey_onibus/set_id_dono", {id = id, user_id = user_id})
        return true
    else
        return false
    end
end

function cnVRP.withdraw(idLoc, valor)
    local source = source
    local user_id = vRP.getUserId(source)

    print(idLoc)
    print(valor)
    local loc = vRP.query("monkey_onibus/get_by_id", {id = idLoc})

    if parseInt(valor) <= loc[1].valorCaixa then
        vRP.addBank(user_id,tonumber(valor))
        -- vRP.giveInventoryItem(user_id, "dollars", valor,true)
        vRP.execute('monkey_onibus/rem_valor_caixa', { id = idLoc, valor = valor })
        return true
    else
        return false
    end
end

function cnVRP.setPorcentagem(idLoc, valor)
    vRP.execute('monkey_onibus/att_porcentagem', { id = idLoc, porcentagemGanho = valor })
end
