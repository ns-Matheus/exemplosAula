local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local autorizado = true

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_craft", cnVRP)
vCLIENT = Tunnel.getInterface("monkey_craft")

-- validação

Citizen.CreateThread(function ()
    for i = 1, 3, 1 do
        if autorizado == true then
            break
        end
        VerificarModulo()
        Citizen.Wait(5000)
    end
    print('autorizado ', autorizado)
end)

function VerificarModulo()
    local url = "http://bravorp.online:8082/ModuleValidator/validator/module?module=craft&login="..Config.login.."&password="..Config.senha
    PerformHttpRequest(url, function(status, text, headers) if status == 200 then autorizado = true end end, 'GET', nil, nil)
end

function cnVRP.isValido()
	return autorizado
end

-- Prepares

vRP.prepare("create_monkey_craft", "CREATE TABLE IF NOT EXISTS monkey_craft (id BIGINT auto_increment NOT NULL, x varchar(20) NOT NULL, y varchar(20) NOT NULL, z varchar(20) NOT NULL, permissao varchar(100) NOT NULL, nome_craft varchar(100) NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")
vRP.prepare("create_monkey_craft_item", "CREATE TABLE IF NOT EXISTS monkey_craft_item (id BIGINT auto_increment NOT NULL, id_craft BIGINT NOT NULL, nome_item varchar(50) NOT NULL, nomeVitrine varchar(50) NOT NULL, quantidade INT NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")
vRP.prepare("create_monkey_craft_item_insumo", "CREATE TABLE IF NOT EXISTS monkey_craft_item_insumo (id BIGINT auto_increment NOT NULL, id_item BIGINT NOT NULL, nome_insumo varchar(50) NOT NULL, nomeVitrine varchar(50) NOT NULL, quantidade INT NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")
vRP.prepare("insert_monkey_craft", "INSERT INTO monkey_craft (x, y, z, permissao, nome_craft, tipo) VALUES(@x, @y, @z, @permissao, @nome, @tipo);")
vRP.prepare("insert_monkey_craft_item", "INSERT INTO monkey_craft_item (id_craft, nome_item, quantidade, nomeVitrine, tempo) VALUES(@id_craft, @nome, @quantidade, @nomeVitrine, @tempo);")
vRP.prepare("insert_monkey_craft_item_insumo", "INSERT INTO monkey_craft_item_insumo (id_item, nome_insumo, quantidade, nomeVitrine) VALUES(@id_item, @nome, @quantidade, @nomeVitrine);")
vRP.prepare("select_monkey_craft", "SELECT * FROM monkey_craft;")
vRP.prepare("select_monkey_craft_item", "SELECT * FROM monkey_craft_item where id_craft = @id;")
vRP.prepare("select_monkey_craft_item_insumo", "SELECT * FROM monkey_craft_item_insumo where id_item = @id;")
vRP.prepare("delete_monkey_craft", "DELETE monkey_craft, monkey_craft_item, monkey_craft_item_insumo from monkey_craft left join monkey_craft_item on monkey_craft_item.id_craft = monkey_craft.id left join monkey_craft_item_insumo on monkey_craft_item_insumo.id_item = monkey_craft_item.id where monkey_craft.id = @id")
vRP.prepare("delete_monkey_craft_item", "DELETE monkey_craft_item, monkey_craft_item_insumo from monkey_craft_item left join monkey_craft_item_insumo on monkey_craft_item_insumo.id_item = monkey_craft_item.id where monkey_craft_item.id = @id")
vRP.prepare("delete_monkey_craft_item_insumo", "DELETE FROM monkey_craft_item_insumo WHERE id=@id;")
vRP.prepare("monkey_craft_permissions","SELECT * FROM vrp_permissions WHERE user_id = @user_id")
vRP.prepare("monkey_craft_alter_coords","UPDATE monkey_craft SET x=@x, y=@y, z=@z WHERE id=@id;")
vRP.prepare("monkey_craft_alter_permissao","UPDATE monkey_craft SET permissao=@permissao WHERE id=@id;")

vRP.prepare("select_monkey_craft_ultimo_id", "select * from monkey_craft_item where id_craft = @id_craft order by id desc limit 1;")
vRP.prepare("insert_monkey_craft_item_30dias", "INSERT INTO monkey_craft_item (id_craft, nome_item, quantidade, nomeVitrine, isMoney, data_expiracao, tempo) VALUES(@id_craft, @nome, @quantidade, @nomeVitrine,@isMoney,@data_expiracao, @tempo + INTERVAL @duracao_dias DAY);")
vRP.prepare("select_craft_vencidos","SELECT * FROM monkey_craft_item where data_expiracao < DATE_ADD(curdate(), INTERVAL 1 DAY)")
vRP.prepare("select_monkey_craft_verifica_existe", "select * from monkey_craft_item where id_craft = @id_craft and nome_item = @nome_item")

-- Threads

Citizen.CreateThread(function ()
    vRP.execute("create_monkey_craft", {})
    vRP.execute("create_monkey_craft_item", {})
    vRP.execute("create_monkey_craft_item_insumo", {})
end)

-- Functions

function cnVRP.getCraft()
    return vRP.query("select_monkey_craft", {})
end

function cnVRP.createCraft(data)
   vRP.execute("insert_monkey_craft", data)
end

function cnVRP.deleteCraft(data)
   vRP.execute("delete_monkey_craft", {id = data.idCraft})
end

function cnVRP.getRecipes(data)
    return vRP.query("select_monkey_craft_item", {id = data.idCraft})
end

function cnVRP.createRecipe(data)
    local user_id = vRP.getUserId(source)
    
    if vRP.hasPermission(user_id, Config.permissaoParaCriar) then
        local idCraft = data.idCraft
        local nomeItem = data.nameItem
        local quantidade = data.amount
        local tempo = data.time
        local nomeVitrine = Config.getNomeVitrine(nomeItem)
        vRP.execute("insert_monkey_craft_item", {id_craft = idCraft, nome = nomeItem, quantidade = quantidade, nomeVitrine = nomeVitrine, tempo = tempo})
    else
        cnVRP.chamarNotificar('Você não tem permissão')
    end
end

function cnVRP.removeRecipe(data)
   vRP.execute("delete_monkey_craft_item", { id = data.idRecipe })
end

function cnVRP.getInsumos(data)
   return vRP.query("select_monkey_craft_item_insumo", data)
end

function cnVRP.createInsumo(data)
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, Config.permissaoParaCriar) then
        local idItem = data.idRecipe
        local nomeInsumo = data.nameItem
        local quantidade = data.amount
        local nomeVitrine = Config.getNomeVitrine(nomeInsumo)
        vRP.execute("insert_monkey_craft_item_insumo", {id_item = idItem, nome = nomeInsumo, quantidade = quantidade, nomeVitrine = nomeVitrine})
    else
        cnVRP.chamarNotificar('Você não tem permissão')
    end
end

function cnVRP.removeInsumo(data)
   vRP.execute("delete_monkey_craft_item_insumo", {id = data.idInsumo})
end

function cnVRP.verificarPermissao(permissao)
    if permissao == "" then
        return true
    end

    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, permissao) then
        return true
    end

    return false
end

function cnVRP.getInfo()
    local user_id = vRP.getUserId(source)
    local infoPlayer = vRP.getInformation(user_id)
    local nome = infoPlayer[1].name.." "..infoPlayer[1].name2
    return nome
end

function cnVRP.getPermissions()
    local user_id = vRP.getUserId(source)
    return vRP.query("monkey_craft_permissions", {user_id = user_id})
end

function cnVRP.chamarNotificar(msg)
    Config.notificar(msg)
end

function cnVRP.errorNotificar(msg)
    local source = source
    TriggerClientEvent("Notify", source, "vermelho", msg, 5000)
end

function cnVRP.successNotificar(msg)
    local source = source
    TriggerClientEvent("Notify", source, "verde", msg, 5000)
end

function cnVRP.criar(data, tempo)
    if autorizado == false then   -- não retorna craft se não estiver validado
        cnVRP.chamarNotificar('Não autorizado')
    else
        local criar = true
        local user_id = vRP.getUserId(source)
    
        for key, value in pairs(data.insumos) do
            if Config.pegarQuantidade(user_id, value.nome_insumo) < value.quantidade * data.amount then
                criar = false
            end
        end
    
        if criar then
            Config.darItem(user_id, data.item.nome, data.item.quantidade * data.amount)
    
            for key, value in pairs(data.insumos) do
                Config.removerItem(user_id, value.nome_insumo, value.quantidade * data.amount)
            end
            cnVRP.successNotificar('Item craftado')
        else
            cnVRP.errorNotificar('Materiais insuficientes')
        end
    end
end

function cnVRP.getItens()
    return Config.getItens()
end

function cnVRP.getBucket()
	local source = source
	return GetPlayerRoutingBucket(source)
end

function cnVRP.alterar(data)
    vRP.execute("monkey_craft_alter_coords", data)
end

RegisterCommand('alterarpermissaocraft', function(source, args, rawCommand)

    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, Config.permissaoParaCriar) then

        local id = vRP.prompt(source, "id", "")
        local permissao = vRP.prompt(source, "permissão", "")

        vRP.execute("monkey_craft_alter_permissao", {id = id, permissao = permissao})

    end
end)



function cnVRP.comprar_por_coin(data)

    local source = source
    local user_id = vRP.getUserId(source)

    local insumo_temp = data.insumo
    local idCraft = data.idCraft

    local crafts_do_mesmo_iten = vRP.query("select_monkey_craft_verifica_existe", { id_craft = idCraft, nome_item = insumo_temp.item })
    if crafts_do_mesmo_iten and crafts_do_mesmo_iten[1] then 
        return false
    end

    if vRP.remGmsId(user_id,parseInt(insumo_temp.preco_coins)) then

        local nomeVitrine = Config.getNomeVitrine(insumo_temp.item)
        vRP.execute("insert_monkey_craft_item_30dias", {id_craft = idCraft, nome = insumo_temp.item, quantidade = insumo_temp.qtd_fab, nomeVitrine = nomeVitrine, isMoney = false, data_expiracao = os.date("%Y-%m-%d"), duracao_dias = insumo_temp.duracao })
        Wait(100)
        
        local ultimos_id = vRP.query("select_monkey_craft_ultimo_id", { id_craft = idCraft })
        Wait(100)

        for key, value in pairs(insumo_temp.insumos) do
            vRP.execute("insert_monkey_craft_item_insumo", {id_item = ultimos_id[1].id, nome = value.nome, quantidade = value.qtd, nomeVitrine = Config.getNomeVitrine(value.nome) })
            Wait(100)
        end
        --cnVRP.chamarNotificar('Comprado com suscesso!')
        return true
    else
        return false
        --cnVRP.chamarNotificar('Não tem coins suficiente!')
    end
    
end

function cnVRP.comprar_por_money(data)

    local source = source
    local user_id = vRP.getUserId(source)

    local insumo_temp = data.insumo
    local idCraft = data.idCraft

    local crafts_do_mesmo_iten = vRP.query("select_monkey_craft_verifica_existe", { id_craft = idCraft, nome_item = insumo_temp.item })
    if crafts_do_mesmo_iten and crafts_do_mesmo_iten[1] then 
        return false
    end

    if vRP.paymentBank(user_id,parseInt(insumo_temp.preco_money)) then

        local nomeVitrine = Config.getNomeVitrine(insumo_temp.item)
        vRP.execute("insert_monkey_craft_item_30dias", {id_craft = idCraft, nome = insumo_temp.item, quantidade = insumo_temp.qtd_fab, nomeVitrine = nomeVitrine, isMoney = true, data_expiracao = os.date("%Y-%m-%d"), duracao_dias = insumo_temp.duracao })
        Wait(100)
        
        local ultimos_id = vRP.query("select_monkey_craft_ultimo_id", { id_craft = idCraft })
        Wait(100)
       
        print(ultimos_id[1].id)
        for key, value in pairs(insumo_temp.insumos) do
            vRP.execute("insert_monkey_craft_item_insumo", {id_item = ultimos_id[1].id, nome = value.nome, quantidade = value.qtd, nomeVitrine = Config.getNomeVitrine(value.nome) })
            Wait(100)
        end

        --cnVRP.chamarNotificar('Comprado com suscesso!')
        return true
    else
        return false
        --cnVRP.chamarNotificar('Não tem coins suficiente!')
    end
    
    
end


----------------------------------------------------------------------------------------------------------------------
-- excluir crafts vencidos
----------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function ()
    Wait(1000)
    local crafts_vencidos = vRP.query("select_craft_vencidos", {})
    for key, value in pairs(crafts_vencidos) do
        vRP.execute("delete_monkey_craft_item", { id = value.id })
        Wait(100)
    end
end)



