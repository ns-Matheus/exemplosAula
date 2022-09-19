local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
-- local autorizado = true

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_outfit", cnVRP)
vCLIENT = Tunnel.getInterface("monkey_outfit")
vSKINSHOP = Tunnel.getInterface("skinshop")

-- validação

-- Citizen.CreateThread(function ()
--     for i = 1, 3, 1 do
--         if autorizado == true then
--             break
--         end
--         VerificarModulo()
--         Citizen.Wait(5000)
--     end
--     print('autorizado ', autorizado)
-- end)

-- function VerificarModulo()
--     local url = "http://bravorp.online:8082/ModuleValidator/validator/module?module=outfit".."&login="..Config.login.."&password="..Config.senha
--     PerformHttpRequest(url, function(status, text, headers) if status == 200 then autorizado = true end end, 'GET', nil, nil)
-- end

-- Prepares

vRP.prepare("create_monkey_outfit", "CREATE TABLE IF NOT EXISTS monkey_outfit (id BIGINT auto_increment NOT NULL, x varchar(20) NOT NULL, y varchar(20) NOT NULL, z varchar(20) NOT NULL, nome varchar(20) NOT NULL, permissao varchar(20) NOT NULL, roupa text NOT NULL, masculino BIT NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")
vRP.prepare("select_monkey_outfit", "select id, x, y, z, nome, permissao, masculino from monkey_outfit")
vRP.prepare("insert_monkey_outfit", "INSERT INTO monkey_outfit (x, y, z, nome, permissao, masculino) VALUES(@x, @y, @z, @nome, @permissao, @masculino);")
vRP.prepare("delete_monkey_outfit", "DELETE FROM monkey_outfit WHERE id=@id;")
vRP.prepare("insert_monkey_outfit_init", "INSERT INTO vrp_srv_data (dkey, dvalue) VALUES(@key,@value);")
vRP.prepare("select_monkey_outfit_init", "select * from vrp_srv_data where dkey = @key;")
vRP.prepare("update_monkey_outfit_init", "UPDATE vrp_srv_data SET dvalue=@value WHERE dkey=@key;")
vRP.prepare("select_monkey_outfit_by_id", "select * from monkey_outfit where id = @id;")

vRP.prepare("select_monkey_outfit_roupas", "select * from monkey_outfit_roupas where id_outfit = @id_outfit;")
vRP.prepare("buscar_roupa_monkey_outfit_roupas", "select * from monkey_outfit_roupas where id = @id;")
vRP.prepare("insert_monkey_outfit_roupas", "INSERT INTO monkey_outfit_roupas (id_outfit, nome, roupa) VALUES (@id_outfit, @nome, @roupa);")
vRP.prepare("delete_monkey_outfit_roupas", "DELETE FROM monkey_outfit_roupas WHERE id=@id;")
vRP.prepare("delete_monkey_outfit_roupas_blip", "DELETE FROM monkey_outfit_roupas WHERE id_outfit=@id_outfit;")
vRP.prepare("permission_by_id","SELECT * FROM vrp_permissions WHERE user_id = @user_id")


-- Functions

function cnVRP.CarregarBlips()
    local rows = vRP.query("select_monkey_outfit", {})
    return rows
end


function cnVRP.criarOutfit(data)
    local source = source
    local user_id = vRP.getUserId(source)
    local nome = vRP.prompt(source, "Nome do outfit?", "")
    local permissao = vRP.prompt(source, "Qual a permissão?", "")
    
    --local result = vRP.getUData(parseInt(user_id), "Clothings")

    --if result and result ~= "" then  
        --local clothes = json.decode(result)  
        --local custom = json.encode(vSKINSHOP.getCustomization(source))
        vRP.execute("insert_monkey_outfit", {x = data.x, y = data.y, z = data.z, nome = nome, permissao = permissao, masculino = data.masculino})
    --end

end

function cnVRP.criarOutfitinit(data)
    local source = source
    local user_id = vRP.getUserId(source)
    --local custom = json.encode(vSKINSHOP.getCustomization(source))

    local result = vRP.getUData(parseInt(user_id), "Clothings")
    if result and result ~= "" then

        local sexo = ""

        if data.masculino then
            local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_inicial_masculina"})
            if #rows >= 1 then
                vRP.execute("update_monkey_outfit_init", { value = result, key = "roupas_inicial_masculina"})
            else
                vRP.execute("insert_monkey_outfit_init", { value = result, key = "roupas_inicial_masculina"})
            end
            sexo = "masculino"
        else
            local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_inicial_feminino"})
            if #rows >= 1 then
                vRP.execute("update_monkey_outfit_init", { value = result, key = "roupas_inicial_feminino"})
            else
                vRP.execute("insert_monkey_outfit_init", { value = result, key = "roupas_inicial_feminino"})
            end
            sexo = "feminino"
        end

        TriggerClientEvent("Notify", source, "amarelo", "Outfit fit salvo com sucesso, todos o players iniciarão com essa roupa do sexo "..sexo, 20000)
    end
end



function cnVRP.aplicarOutfitInit(masculino)
    local source = source

    if masculino then
        local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_inicial_masculina"})
        if #rows >=1 then
            local result = json.decode(rows[1].dvalue)
            TriggerClientEvent("updateRoupas",source,result)
        else
            local resultData = "clean"
			TriggerClientEvent("skinshop:skinData",source,resultData)
        end
    else
        local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_inicial_feminino"})
        if #rows >=1 then
            local result = json.decode(rows[1].dvalue)
            TriggerClientEvent("updateRoupas",source,result)
        else
            local resultData = "clean"
			TriggerClientEvent("skinshop:skinData",source,resultData)
        end
    end
end


-- function cnVRP.criarOutfitPrisao(data)
--     local source = source
--     local user_id = vRP.getUserId(source)
--     --local custom = json.encode(vSKINSHOP.getCustomization(source))

--     local result = vRP.getUData(parseInt(user_id), "Clothings")
--     if result and result ~= "" then

--         local sexo = ""

--         if data.masculino then
--             local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_prisao_masculina"})
--             if #rows >= 1 then
--                 vRP.execute("update_monkey_outfit_init", { value = result, key = "roupas_prisao_masculina"})
--             else
--                 vRP.execute("insert_monkey_outfit_init", { value = result, key = "roupas_prisao_masculina"})
--             end
--             sexo = "masculino"
--         else
--             local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_prisao_feminino"})
--             if #rows >= 1 then
--                 vRP.execute("update_monkey_outfit_init", { value = result, key = "roupas_prisao_feminino"})
--             else
--                 vRP.execute("insert_monkey_outfit_init", { value = result, key = "roupas_prisao_feminino"})
--             end
--             sexo = "feminino"
--         end

--         TriggerClientEvent("Notify", source, "amarelo", "Outfit fit salvo com sucesso, todos o players que forem presos usarão essa roupa do sexo "..sexo, 20000)
--     end
-- end


function cnVRP.aplicarOutfitPrisao(masculino)
    local source = source

    if masculino then
        local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_prisao_masculina"})
        if #rows >=1 then
            local result = json.decode(rows[1].dvalue)
            TriggerClientEvent("updateRoupas",source,result)
        else
            local resultData = "clean"
			TriggerClientEvent("skinshop:skinData",source,resultData)
        end
    else
        local rows = vRP.query("select_monkey_outfit_init", { key = "roupas_prisao_feminino"})
        if #rows >=1 then
            local result = json.decode(rows[1].dvalue)
            TriggerClientEvent("updateRoupas",source,result)
        else
            local resultData = "clean"
			TriggerClientEvent("skinshop:skinData",source,resultData)
        end
    end
end


function cnVRP.chamarNotificar(msg)
    local source = source
    TriggerClientEvent("Notify", source, "amarelo", msg, 5000)
end

function cnVRP.verificarPermissao(permissao)
    -- if autorizado == true then
        if permissao == "" then
            return true
        end
        local user_id = vRP.getUserId(source)
        if vRP.hasPermission(user_id, permissao) then
            return true
        end
        -- return false
    -- end
    return false
end


function cnVRP.verificarPermissaoAdmin()
    return Config.Admin
end

-- ADICIIONAR Outfits
-- function cnVRP.adicionarOutfit(data)
--     local source = source
--     local result = json.decode(data)
--     TriggerClientEvent("updateRoupas",source, json.encode(result))
--     TriggerClientEvent("Notify", source, "amarelo", "Outfit aplicado com sucesso.", 5000)
-- end




-- SALVAR Outfits_teste
function cnVRP.aplicarClotesOutfit(id)
    local source = source
    local user_id = vRP.getUserId(source)

    local rows = vRP.query("buscar_roupa_monkey_outfit_roupas", { id = parseInt(id)})
  
    local clothes = json.decode(rows[1].roupa)

    vRP.setUData(user_id,"Clothings",json.encode(clothes))
    TriggerClientEvent("monkey:setClothingOutFit",source,clothes)

    TriggerClientEvent("Notify", source, "amarelo", "Outfit aplicado com sucesso.", 5000)
end


-- LISTAR Outfits_teste
function cnVRP.listaOutfit(id)
    local source = source
    local user_id = vRP.getUserId(source)
    local retorno = {}
    -- Busca do banco
    local listaOutfit = vRP.query("select_monkey_outfit_roupas", { id_outfit = id})
    local permissoes = vRP.query("permission_by_id", { user_id =user_id})
    retorno.listaOutfit = listaOutfit
    retorno.permissoes = permissoes
    -- for k, v in pairs(listaOutfit) do
	-- 	local item = {
	-- 		['idOutfit'] = v.id,
	-- 		["nomeOutfit"] = v.nome,
	-- 	}
	-- 	table.insert(v, k)
	-- 	listaOutfit[k] = item
	-- end
    return retorno
end


-- ADICIONAR Outfits_teste
function cnVRP.AdicionarOutfit(id, nome)
    local source = source
    local user_id = vRP.getUserId(source)
    local result = vRP.getUData(parseInt(user_id), "Clothings")
    if result and result ~= "" then  
        local clothes = json.decode(result)
        -- Insere no banco
        vRP.execute("insert_monkey_outfit_roupas", {id_outfit = id , nome = nome, roupa = json.encode(clothes)})
        local retorno = {}
        -- Busca do banco
        local listaOutfit = vRP.query("select_monkey_outfit_roupas", { id_outfit = id})
        retorno.listaOutfit = listaOutfit
        return retorno.listaOutfit
    end
end


-- DELETAR CARDS Outfits_teste
function cnVRP.deletarOutfitCard(data)
    vRP.execute("delete_monkey_outfit_roupas", {id = data})
end


-- DELETAR BLIP Outfits_teste
function cnVRP.deletarOutfitBlip(data)
    vRP.execute("delete_monkey_outfit", {id = data})
    vRP.execute("delete_monkey_outfit_roupas_blip", {id_outfit = data})
end