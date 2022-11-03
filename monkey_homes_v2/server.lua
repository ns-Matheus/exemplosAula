local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface(GetCurrentResourceName(),emP)
vCLIENT = Tunnel.getInterface(GetCurrentResourceName())
local autorizado = true

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
    local url = "http://bravorp.online:8082/ModuleValidator/validator/module?module=monkey_homes".."&login="..config.login.."&password="..config.senha
    PerformHttpRequest(url, function(status, text, headers) if status == 200 then autorizado = true end end, 'GET', nil, nil)
end

function emP.isValido()
	return autorizado
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookbaucasas = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare('vRP/insert_home','INSERT INTO homes(interior, bau, apartamento, cds,nome, valor, coins, qtd_chaves, transferivel, disponivel, foto) VALUES(@interior, @bau, @apartamento, @cds, @nome, @valor, @coins, @qtd_chaves, 0, @disponivel, @foto)')
vRP._prepare('vRP/update_home','UPDATE homes SET interior = @interior, bau = @bau, apartamento = @apartamento, nome = @nome, valor = @valor, valor_acresc = @valor_acresc, qtd_chaves = @qtd_chaves WHERE nome = @nome_ant')
vRP._prepare('vRP/update_transf','UPDATE homes SET transferivel = @transferivel WHERE nome = @nome')
vRP._prepare('vRP/update_disp','UPDATE homes SET disponivel = @disponivel WHERE nome = @nome')
vRP._prepare('vRP/update_users_homes','UPDATE users_homes SET nome = @nome, interior = @interior WHERE nome = @nome_ant')
vRP._prepare('vRP/transfer_home','UPDATE users_homes SET user_id = @user_id WHERE nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/gethas_home','SELECT * FROM users_homes WHERE user_id = @user_id')
vRP._prepare('vRP/get_homes','SELECT * FROM homes')
vRP._prepare('vRP/get_homes_data','SELECT * FROM homes WHERE nome = @nome')
vRP._prepare('vRP/get_home_details','SELECT * FROM users_homes WHERE nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/buy_home','INSERT INTO users_homes(user_id, nome, interior, apartamento,iptu,expire_home, isOwner,bau,qtd_chaves) VALUES(@user_id, @nome, @interior, @apartamento, @iptu, @expire_home, @isOwner, @bau, @qtd_chaves)')
vRP._prepare('vRP/remove_home','DELETE FROM users_homes WHERE user_id = @user_id AND nome = @nome AND apartamento = @apartamento ')
vRP._prepare('vRP/get_home_user_is','SELECT * FROM session WHERE user_id = @user_id')
vRP._prepare('vRP/get_apartaments_availables','SELECT * FROM users_homes WHERE nome = @nome')
vRP._prepare('vRP/insert_session','INSERT INTO session(user_id, world, interior, nome, apartamento) VALUES(@user_id, @world, @interior, @nome, @apartamento)')
vRP._prepare('vRP/remove_session','DELETE FROM session WHERE user_id = @user_id AND world = @world AND nome = @nome')
vRP._prepare('vRP/insert_temp_session','INSERT INTO session_temp(user_id, interior, nome, apartamento) VALUES(@user_id, @interior, @nome, @apartamento)')
vRP._prepare('vRP/remove_temp_session','DELETE FROM session_temp WHERE user_id = @user_id')
vRP._prepare('vRP/get_temp_session','SELECT * FROM session_temp WHERE user_id = @user_id')
vRP._prepare('vRP/get_sessions_active_by_interior','SELECT * FROM session WHERE interior = @interior')
vRP._prepare('vRP/get_sessions_active_by_nome','SELECT * FROM session WHERE nome = @nome')
vRP._prepare('vRP/get_someone_INDAHOUSE','SELECT * FROM session WHERE nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/get_iptu','SELECT iptu,expire_home FROM users_homes WHERE user_id = @user_id AND apartamento = @apartamento AND nome = @nome')
vRP._prepare('vRP/update_iptu','UPDATE users_homes SET iptu = @iptu, expire_home = @expire_home WHERE nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/insert_perm','INSERT INTO homes_permission(user_id, nome, apartamento) VALUES(@user_id, @nome, @apartamento)')
vRP._prepare('vRP/remove_perm','DELETE FROM homes_permission WHERE user_id = @user_id AND nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/remove_all_perm','DELETE FROM homes_permission WHERE nome = @nome AND apartamento = @apartamento')
vRP._prepare('vRP/get_homes_permission','SELECT * FROM homes_permission WHERE nome = @nome AND apartamento = @apartamento')

vRP._prepare('vRP/unlockHome','UPDATE users_homes SET isLocked = false WHERE nome = @name and apartamento = @apto')
vRP._prepare('vRP/lockHome','UPDATE users_homes SET isLocked = true WHERE nome = @name and apartamento = @apto')

vRP._prepare('vRP/addPersonHome','INSERT INTO users_homes (apartamento, expire_home, interior, iptu, nome, user_id,bau,qtd_chaves) VALUES(@apto, @expire, @interior, @iptu, @nome, @user_id, @bau, @qtd_chaves)')
vRP._prepare('vRP/remPersonHome','DELETE FROM users_homes WHERE apartamento = @apto and nome = @nome and user_id  = @user_id')

vRP._prepare('vRP/getAuthorizedPersons','SELECT user_id FROM users_homes where apartamento = @apto and nome = @nome')

vRP._prepare('vRP/getHomesById','SELECT * FROM homes WHERE id = @id')

vRP.prepare("vRP/getHousesUsers", "SELECT * FROM users_homes")
vRP.prepare("vRP/lockHouses", "UPDATE users_homes SET isLocked = true WHERE isLocked = false")

vRP.prepare("vRP/attInteriorHouse", "UPDATE users_homes SET interior = @interior WHERE apartamento = @apto and nome = @nome")
vRP.prepare("vRP/upgKeysHouse", "UPDATE users_homes SET qtd_chaves = qtd_chaves + @key WHERE apartamento = @apto and nome = @nome")
vRP.prepare("vRP/upgBauHouse", "UPDATE users_homes SET bau = bau + @bau WHERE apartamento = @apto and nome = @nome")

vRP.prepare('vRP/getHomesByName','SELECT * FROM homes WHERE nome = @nome')
vRP.prepare('vRP/attCoordBau','UPDATE users_homes SET coordBau = @coord WHERE nome = @nome and apartamento = @apto')
vRP.prepare('vRP/attCoordPainel','UPDATE users_homes SET coordPainel = @coord WHERE nome = @nome and apartamento = @apto')



-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local last_world_available = 0
local last_apartament_available = 1
local is_apartament_available = 1
local igual = false
local diferente = false
local setado = false
local blipHomes = {}
local worldpadrao = 0
local actived = {}

local homes = nil

-- moveis casas
local objetos = {}
local mundos_moveis = {}


-- emP.buyHome
function emP.buyHome(id, apto, type)
    local source = source
	local user_id = vRP.getUserId(source)

    local home = vRP.query("vRP/getHomesById", {id = id})

    local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})

    if #homeDetails > 0 then
        if homeDetails[1].user_id == user_id then
            TriggerClientEvent('Notify',source,'importante','Essa casa já é sua.',15000)
        else
            TriggerClientEvent('Notify',source,'negado','Essa casa não está disponível para venda pela imobiliária.',15000)
        end
    else
        -- if vRP.request(source,"Deseja comprar essa casa no valor de R$"..vRP.format(home[1].valor).."?",30) then
        local casa_comprada = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        if #casa_comprada > 0 then
            TriggerClientEvent('Notify',source,'negado','Essa casa já foi comprada.',15000) 
            return
        else
            if type == "Dinheiro" then
                if vRP.paymentBank(user_id,parseInt(home[1].valor)) then
                    local iptu = calculaDias(config.diasIPTU)
                    local expire_home = calculaDias(config.diasIPTU + config.diasRemoverHome)
                    vRP.execute('vRP/buy_home', {
                        ['user_id'] = user_id,
                        ["nome"] = home[1].nome,
                        ["interior"] = config.upgrades[home[1].interior].casas[1].i,
                        ["apartamento"] = apto,
                        ["iptu"] = iptu,
                        ["expire_home"] = expire_home,
                        ["isOwner"] = true,
                        ['bau'] = config.upgrades[home[1].interior].init_bau,
                        ['qtd_chaves'] = config.upgrades[home[1].interior].init_chaves
                    })
                    vRP.execute('vRP/insert_perm', {
                        ['user_id'] = user_id,
                        ["nome"] = home[1].nome,
                        ["apartamento"] = apto
                    }) 
                    vRP.execute('vRP/update_disp', {
                        ['disponivel'] = home[1].disponivel - 1,
                        ['nome'] = home[1].nome
                    })
                    -- TriggerClientEvent('Notify',source,'sucesso','Parabéns, essa casa agora é sua.',15000) 

                    return "sucesso"
                else
                    return "erro"
                    -- TriggerClientEvent('Notify',source,'negado','Você não possui o valor suficiente.',15000)  
                end
            elseif type == "Coins" then
                if vRP.remGmsId(user_id,parseInt(home[1].coins)) then
                    local iptu = calculaDias(config.diasIPTU)
                    local expire_home = calculaDias(config.diasIPTU + config.diasRemoverHome)
                    vRP.execute('vRP/buy_home', {
                        ['user_id'] = user_id,
                        ["nome"] = home[1].nome,
                        ["interior"] = config.upgrades[home[1].interior].casas[1].i,
                        ["apartamento"] = apto,
                        ["iptu"] = iptu,
                        ["expire_home"] = expire_home,
                        ["isOwner"] = true,
                        ['bau'] = config.upgrades[home[1].interior].init_bau,
                        ['qtd_chaves'] = config.upgrades[home[1].interior].init_chaves
                    })
                    vRP.execute('vRP/insert_perm', {
                        ['user_id'] = user_id,
                        ["nome"] = home[1].nome,
                        ["apartamento"] = apto
                    }) 
                    vRP.execute('vRP/update_disp', {
                        ['disponivel'] = home[1].disponivel - 1,
                        ['nome'] = home[1].nome
                    })
                    -- TriggerClientEvent('Notify',source,'sucesso','Parabéns, essa casa agora é sua.',15000)

                    return "sucesso"
                else
                    return "erro"
                    -- TriggerClientEvent('Notify',source,'negado','Você não possui o valor suficiente.',15000)  
                end
            end
        end
        -- end
    end

end

-- emP.remPermHome
function emP.disallowPerson(name, apto, idPlayer)
    vRP.execute("vRP/remPersonHome", {apto = apto, nome = name, user_id = idPlayer})
end

-- emP.addPermHome
function emP.authorizePerson(id, apto, idPlayer)
    local home = vRP.query("vRP/getHomesById", {id = id})
    local rows = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})

    vRP.execute("vRP/addPersonHome", {apto = rows[1].apartamento, expire = rows[1].expire_home, interior = rows[1].interior, iptu = rows[1].iptu, nome = rows[1].nome, user_id = idPlayer, bau = rows[1].bau, qtd_chaves = rows[1].qtd_chaves})
end

-- emP.transferHome
function emP.transferHome(id, value, nuser_id, apto)
    local source = source
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserSource(parseInt(nuser_id))

    local rows = vRP.query("vRP/getHomesById", {id = id})
    local homeDetails = vRP.query('vRP/get_home_details', {nome = rows[1].nome, apartamento = apto})

    if (user_id and nplayer) then
        if rows[1].transferivel == 0 then
            if rows[1].apartamento ~= -1 then
                local identity = vRP.getUserIdentity(user_id)
                local identityn = vRP.getUserIdentity(nuser_id)
                if vRP.request(nplayer,"Deseja adquirir o imóvel "..rows[1].nome.." do cidadão "..identity.name.." por R$"..value.."?",30) then
                    if vRP.paymentBank(nuser_id,parseInt(value)) then
                        vRP.giveBankMoney(user_id,value)

                        vRP.execute('vRP/transfer_home', { ['user_id'] = nuser_id, ['nome'] = rows[1].nome, ['apartamento'] = apto })
                        vRP.execute('vRP/remove_all_perm', { ["nome"] = rows[1].nome, ["apartamento"] = apto })
                        vRP.execute('vRP/insert_perm', { ['user_id'] = nuser_id, ["nome"] = rows[1].nome, ["apartamento"] = apto }) 

                        TriggerClientEvent('Notify',source,'sucessso','Você vendeu o imóvel '..rows[1].nome..'['..apto..'] para o [ID]: '..nuser_id..' com sucesso',15000)
                        TriggerClientEvent('Notify',nplayer,'sucessso','Você comprou o imóvel '..rows[1].nome..'['..apto..'] do [ID]: '..user_id..' com sucesso',15000)
                        return "sucesso"
                    else
                        TriggerClientEvent('Notify',source,'negado','O cidadão não possui o valor necessário.',15000)
                        TriggerClientEvent('Notify',nplayer,'negado','Você não possui o valor necessário.',15000)
                        return "erro"
                    end
                else
                    return "erro"
                end
            else
                local identity = vRP.getUserIdentity(user_id)
                local identityn = vRP.getUserIdentity(nuser_id)
                if vRP.request(nplayer,"Deseja adquirir o imóvel "..rows[1].nome.." do cidadão "..identity.name.." por R$"..value.."?",30) then 
                    if vRP.paymentBank(nuser_id,parseInt(value)) then
                        vRP.giveBankMoney(user_id,value)

                        vRP.execute('vRP/transfer_home', { ['user_id'] = nuser_id, ['nome'] = rows[1].nome, ['apartamento'] = -1 })
                        vRP.execute('vRP/remove_all_perm', { ["nome"] = rows[1].nome, ["apartamento"] = -1 })
                        vRP.execute('vRP/insert_perm', { ['user_id'] = nuser_id, ["nome"] = rows[1].nome, ["apartamento"] = -1 }) 

                        TriggerClientEvent('Notify',source,'sucessso','Você vendeu o imóvel '..rows[1].nome..' para o [ID]: '..nuser_id..' com sucesso',15000)
                        TriggerClientEvent('Notify',nplayer,'sucessso','Você comprou o imóvel '..rows[1].nome..' do [ID]: '..user_id..' com sucesso',15000)
                        return "sucesso"
                    else
                        TriggerClientEvent('Notify',source,'negado','O cidadão não possui o valor necessário.',15000)
                        TriggerClientEvent('Notify',nplayer,'negado','Você não possui o valor necessário.',15000)
                        return "erro"
                    end
                else
                    return "erro"
                end
            end
        else
            return "erro"
        end
    else
        return "erro"
    end
end

-- emP.payTax
function emP.payHomeTax(id, apto)
    local source = source
	local user_id = vRP.getUserId(source)

    local home = vRP.query("vRP/getHomesById", {id = id})

    if home[1].apartamento ~= -1 then
        local info_ap = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        local valor_pay = home[1].valor * (config.taxaIPTU / 100)
        -- if vRP.request(source,"Deseja pagar a taxa no valor de R$"..valor_pay.."?",30) then 
        if vRP.paymentBank(user_id,parseInt(valor_pay)) then
            local iptu = info_ap[1].iptu + (24*config.diasIPTU*60*60)
            local expire_home = info_ap[1].expire_home + (24*(config.diasIPTU)*60*60)

            vRP.execute('vRP/update_iptu', { ['iptu'] = iptu, ["expire_home"] = expire_home, ["nome"] = home[1].nome, ["apartamento"] = apto })
            return "sucesso"
        else
            return "erro"
        end
        -- end
    else
        local info_home = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = -1})    
        local valor_pay = home[1].valor * (config.taxaIPTU / 100)
        if vRP.paymentBank(user_id,parseInt(valor_pay)) then
            local iptu = info_home[1].iptu + (24*config.diasIPTU*60*60)
            local expire_home = info_home[1].expire_home + (24*(config.diasIPTU)*60*60)

            vRP.execute('vRP/update_iptu', {['iptu'] = iptu, ["expire_home"] = expire_home, ["nome"] = home[1].nome, ["apartamento"] = -1 })
            return "sucesso"
        else
            return  "erro"
        end
    end
end

function emP.unlockHome(name, apto)
    vRP.execute("vRP/unlockHome", {name = name, apto = apto})
end

function emP.lockHome(name, apto)
    vRP.execute("vRP/lockHome", {name = name, apto = apto})
end

function emP.enterHome(id, apto)
    local source = source
    local user_id = vRP.getUserId(source)
    local home = vRP.query("vRP/getHomesById", {id = id})
    
    local identity = vRP.getUserIdentity(user_id)


    if home[1].apartamento ~= -1 then
        local rows = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        local interior = rows[1].interior

        if verificaIPTUAP(rows[1].user_id,home[1].nome,apto) then
            local ap_active = vRP.query('vRP/get_someone_INDAHOUSE', { nome = home[1].nome, apartamento = apto })
            local cds_home = config.homes[rows[1].interior].porta_dentro
            local cds_painel = config.homes[rows[1].interior].painel
            local cds_bau = config.homes[rows[1].interior].bau
            -- if #ap_active > 0 then
            --     vRP.execute('vRP/insert_session', {
            --         ['user_id'] = user_id,
            --         ["world"] = id,
            --         ["interior"] = ap_active[1].interior,
            --         ["apartamento"] = apto,
            --         ['nome'] = ap_active[1].nome
            --     })
            --     TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
            --     vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
            --     changeSession(user_id,id)

            --     return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z
            -- else  
                -- last_world_available = 0
                -- local rows = vRP.query('vRP/get_sessions_active_by_interior', { interior = rows[1].interior })
                -- if #rows > 0 then
                                
                --     repeat
                --         for k,v in pairs(rows) do
                --             if v.world == last_world_available then
                --                 igual = true
                --             end
                --         end
    
                --         if not igual then
                --             vRP.execute('vRP/insert_session', {
                --                 ['user_id'] = user_id,
                --                 ["world"] = id,
                --                 ["interior"] = interior,
                --                 ["apartamento"] = apto,
                --                 ['nome'] = home[1].nome
                --             })
                --             TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                --             vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                --             changeSession(user_id,id)
                --             setado = true
                --         end
    
                --         igual = false
                --         last_world_available = last_world_available + 1
                --     until setado == true
                --     setado = false
                --     return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z
                -- else
            vRP.execute('vRP/insert_session', {
                ['user_id'] = user_id,
                ["world"] = home[1].id.."999"..apto,
                ["interior"] = interior,
                ["apartamento"] = apto,
                ['nome'] = home[1].nome
            })
            TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
            vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)

            local mundo_temp = parseInt(home[1].id.."999"..apto)

            changeSession(user_id,mundo_temp)

            
                
            return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z, getMoveisMundo(mundo_temp)
            -- end  
            -- end
        end
    else
        local rows = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = -1})
        if #rows > 0 then
            local interior = rows[1].interior
            if verificaIPTUCasa(rows[1].user_id,home[1].nome) then
                local house_active = vRP.query('vRP/get_someone_INDAHOUSE', { nome = home[1].nome, apartamento = -1 })
                local cds_home = config.homes[rows[1].interior].porta_dentro
                local cds_painel = config.homes[rows[1].interior].painel
                local cds_bau = config.homes[rows[1].interior].bau
                -- if #house_active > 0 then
                    vRP.execute('vRP/insert_session', {
                        ['user_id'] = user_id,
                        ["world"] = home[1].id,
                        ["interior"] = interior,
                        ["apartamento"] = -1,
                        ['nome'] = home[1].nome
                    })
                    TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                    vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                    local mundo_temp = parseInt(home[1].id)
                    changeSession(user_id,mundo_temp)

                    return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z, getMoveisMundo(mundo_temp)
                -- else  
                --     last_world_available = 0
                --     local rows = vRP.query('vRP/get_sessions_active_by_interior', { interior = rows[1].interior })
                --     if #rows > 0 then
                                    
                --         repeat
                --             for k,v in pairs(rows) do
                --                 if v.world == last_world_available then
                --                     igual = true
                --                 end
                --             end
        
                --             if not igual then
                --                 vRP.execute('vRP/insert_session', {
                --                     ['user_id'] = user_id,
                --                     ["world"] = last_world_available,
                --                     ["interior"] = interior,
                --                     ["apartamento"] = -1,
                --                     ['nome'] = home[1].nome
                --                 })
                --                 TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                --                 vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                --                 changeSession(user_id,last_world_available)
                --                 setado = true
                --             end
        
                --             igual = false
                --             last_world_available = last_world_available + 1
                --         until setado == true
                --         setado = false
                --         return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z
                --     else
                --         vRP.execute('vRP/insert_session', {
                --             ['user_id'] = user_id,
                --             ["world"] = 0,
                --             ["interior"] = interior,
                --             ["apartamento"] = -1,
                --             ['nome'] = home[1].nome
                --         })
                --         TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                --         vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                --         changeSession(user_id,0)
                --         return cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z
                --     end                            
                -- end
            end
        end
    end

end

function emP.pegarCasas()
    local source = source
    local user_id = vRP.getUserId(source)

    if homes == nil then
        homes = carregarCasas()
    end

    -- local retorno = homes

    -- for k,v in pairs(retorno) do
    --     if v.aptos then
    --         for k1,v1 in pairs(v.aptos) do
    --             v1.idPlayer = user_id
    --         end
    --     else
    --         v.idPlayer = user_id
    --     end
    -- end

    return homes
end

Citizen.CreateThread(function()
    homes = carregarCasas()
end)

function emP.getInfoCasa(id)
    local source = source
    local user_id = vRP.getUserId(source)

    local home = vRP.query("vRP/getHomesById", {id = id})

    local v = home[1]

    if v.apartamento == -1 then
        local home = {}

        local homeDetails = vRP.query('vRP/get_home_details', {nome = v.nome, apartamento = v.apartamento})

        home.idPlayer = user_id
        home.hasOwner = false
        home.ownerName = nil
        home.ownerPhone = nil
        home.ownerId = nil
        home.expirationDate = nil
        
        if #homeDetails > 0 then
            local infoPlayer = vRP.getInformation(homeDetails[1].user_id)

            home.hasOwner = true
            home.ownerName = infoPlayer[1].name.." "..infoPlayer[1].name2
            home.ownerPhone = infoPlayer[1].phone
            home.ownerId = homeDetails[1].user_id
            home.expirationDate = homeDetails[1].expire_home
            home.locked = homeDetails[1].isLocked
            home.homeChestWeight = homeDetails[1].bau
            home.homeKeyAmount = homeDetails[1].qtd_chaves
            if config.upgrades[v.interior] ~= nil then
                home.upgradeChestValue = config.calcularUpgradeBau(homeDetails[1].bau, config.upgrades[v.interior])
                home.upgradeKeysValue = config.calcularUpgradeChave(homeDetails[1].qtd_chaves, config.upgrades[v.interior])
                local interiores = {}

                for k,v in pairs(config.upgrades[v.interior].casas) do
                    local interior = {}

                    interior.name = v.i
                    interior.value = v.v
                    interior.photo = config.homes[v.i].foto

                    table.insert(interiores, interior)
                end

                home.interiors = interiores
            end
            home.homeInterior = homeDetails[1].interior
        else
            home.homeChestWeight = v.bau
            home.homeKeyAmount = v.qtd_chaves
        end

        home.homeValue = v.valor
        home.homeName = v.nome
        home.homeApto = v.apartamento
        home.homeId = v.id
        home.homePhoto = v.foto
        home.iptu = home.homeValue * (config.taxaIPTU / 100)
        home.homeValueCoins = v.coins
        home.authorizedPersons = {}

        local persons = vRP.query("vRP/getAuthorizedPersons", {apto = v.apartamento, nome = v.nome})
        
        for k,v in pairs(persons) do
            local infoPlayer = vRP.getInformation(v.user_id)
            local person = {}

            person.id = v.user_id
            person.name = infoPlayer[1].name.." "..infoPlayer[1].name2
            person.phone = infoPlayer[1].phone

            table.insert(home.authorizedPersons, person)
        end

        local cds = json.decode(v.cds)

        home.x = cds.x
        home.y = cds.y
        home.z = cds.z

        return home
    else
        local aptos = {}

        for i=1,v.apartamento do
            local home = {}

            local homeDetails = vRP.query('vRP/get_home_details', {nome = v.nome, apartamento = i})

            home.idPlayer = user_id
            home.hasOwner = false
            home.ownerName = nil
            home.ownerPhone = nil
            home.ownerId = nil
            home.expirationDate = nil
            
            if #homeDetails > 0 then
                local infoPlayer = vRP.getInformation(homeDetails[1].user_id)
    
                home.hasOwner = true
                home.ownerName = infoPlayer[1].name.." "..infoPlayer[1].name2
                home.ownerPhone = infoPlayer[1].phone
                home.ownerId = homeDetails[1].user_id
                home.expirationDate = homeDetails[1].expire_home
                home.locked = homeDetails[1].isLocked
                home.homeChestWeight = homeDetails[1].bau
                home.homeKeyAmount = homeDetails[1].qtd_chaves

                if config.upgrades[v.interior] ~= nil then
                    home.upgradeChestValue = config.calcularUpgradeBau(homeDetails[1].bau, config.upgrades[v.interior])
                    home.upgradeKeysValue = config.calcularUpgradeChave(homeDetails[1].qtd_chaves, config.upgrades[v.interior])
                    local interiores = {}

                    for k,v in pairs(config.upgrades[v.interior].casas) do
                        local interior = {}
    
                        interior.name = v.i
                        interior.value = v.v
                        interior.photo = config.homes[v.i].foto
    
                        table.insert(interiores, interior)
                    end
    
                    home.interiors = interiores
                end
                home.homeInterior = homeDetails[1].interior
            else
                home.homeChestWeight = v.bau
                home.homeKeyAmount = v.qtd_chaves
            end

            home.homeApto = i
            home.homeValue = v.valor
            home.homeName = v.nome
            home.homeId = v.id
            home.homePhoto = v.foto
            home.iptu = home.homeValue * (config.taxaIPTU / 100)
            home.homeValueCoins = v.coins
            home.authorizedPersons = {}

            local persons = vRP.query("vRP/getAuthorizedPersons", {apto = i, nome = v.nome})
            
            for k,v in pairs(persons) do
                local infoPlayer = vRP.getInformation(v.user_id)
                local person = {}
    
                person.id = v.user_id
                person.name = infoPlayer[1].name.." "..infoPlayer[1].name2
                person.phone = infoPlayer[1].phone
    
                table.insert(home.authorizedPersons, person)
            end
            
            table.insert(aptos,home)
        end

        local apartementos = {}
        
        apartementos.aptos = aptos

        local cds = json.decode(v.cds)

        apartementos.x = cds.x
        apartementos.y = cds.y
        apartementos.z = cds.z
        
        return aptos
    end
    
end

function emP.changeInterior(id, apto, interior)
    local source = source
    local user_id = vRP.getUserId(source)
    local home = vRP.query("vRP/getHomesById", {id = id})

    if config.upgrades[home[1].interior] ~= nil then
        local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        local valorUpgrade = config.calcularUpgradeBau(homeDetails[1].bau, config.upgrades[home[1].interior])

        for k,v in pairs(config.upgrades[home[1].interior].casas) do
            if v.i == interior then
                if vRP.paymentBank(user_id,parseInt(v.v)) then
                    vRP.execute("vRP/attInteriorHouse", {interior = v.i, apto = apto, nome = home[1].nome})
                    return "sucesso"
                else
                    return "erro"
                end
            end
        end
    end
end

function emP.upgradeKeys(id, apto)
    local source = source
    local user_id = vRP.getUserId(source)
    local home = vRP.query("vRP/getHomesById", {id = id})

    if config.upgrades[home[1].interior] ~= nil then
        local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        local valorUpgrade = config.calcularUpgradeChave(homeDetails[1].qtd_chaves, config.upgrades[home[1].interior])
        if vRP.paymentBank(user_id,parseInt(valorUpgrade)) then

            vRP.execute("vRP/upgKeysHouse", {key = config.upgrades[home[1].interior].init_chaves, apto = apto, nome = home[1].nome})

            local retorno = {}
            retorno.homeKeyAmount = homeDetails[1].qtd_chaves + config.upgrades[home[1].interior].init_chaves
            retorno.upgradeKeysValue = config.calcularUpgradeChave(parseInt(retorno.homeKeyAmount), config.upgrades[home[1].interior])

            return retorno
        else
            return "erro"
        end
    end
end

function emP.upgradeChest(id, apto)
    local source = source
    local user_id = vRP.getUserId(source)
    local home = vRP.query("vRP/getHomesById", {id = id})

    if config.upgrades[home[1].interior] ~= nil then
        local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
        local valorUpgrade = config.calcularUpgradeBau(homeDetails[1].bau, config.upgrades[home[1].interior])
        if vRP.paymentBank(user_id,parseInt(valorUpgrade)) then

            vRP.execute("vRP/upgBauHouse", {bau = config.upgrades[home[1].interior].init_bau, apto = apto, nome = home[1].nome})

            local retorno = {}
            retorno.homeChestWeight = homeDetails[1].bau + config.upgrades[home[1].interior].init_bau
            retorno.upgradeChestValue = config.calcularUpgradeBau(parseInt(retorno.homeChestWeight), config.upgrades[home[1].interior])

            return retorno
        else
            return "erro"
        end
    end
end

vRP.prepare('vRP/getFunitures','SELECT * FROM monkey_homes_moveis')
vRP.prepare('vRP/getFunituresUser','SELECT * FROM monkey_homes_moveis_user where user_id = @user_id')
vRP.prepare('vRP/getFurniturebyId','SELECT * FROM monkey_homes_moveis where id = @id')
vRP.prepare('vRP/getFunituresbyName','SELECT * FROM monkey_homes_moveis where nome = @nome')
vRP.prepare('vRP/getFunituresUserbyId','SELECT * FROM monkey_homes_moveis_user where id = @id')
vRP.prepare('vRP/addFurnitureUser','INSERT INTO monkey_homes_moveis_user (nome, nome_vitrine, url_foto, user_id, usado, correcao_z) VALUES(@nome, @nome_vitrine, @url_foto, @user_id, 0, @correcao_z)')
vRP.prepare('vRP/delFurnitureUser','DELETE FROM monkey_homes_moveis_user WHERE id = @id')
vRP.prepare('vRP/attUsedFurniture','UPDATE monkey_homes_moveis_user SET usado = @usado WHERE id = @id;')


vRP.prepare('vRP/getPositionMoveis','SELECT * FROM monkey_homes_moveis_position where codigo_mundo = @codigo_mundo')
vRP.prepare('vRP/getPositionMoveisbyID','SELECT * FROM monkey_homes_moveis_user where id = @id')
vRP.prepare('vRP/getPositionMoveisbyID_Movel','SELECT * FROM monkey_homes_moveis_position where id_movel_user = @id_movel_user')


vRP.prepare('vRP/addMoveisLoja','INSERT INTO monkey_homes_moveis (nome, nome_vitrine, url_foto, preco, coins, correcao_z) VALUES(@nome, @nome_vitrine, @url_foto, @preco, @coins, 0)')

vRP.prepare('vRP/addPositionMoveis','INSERT INTO monkey_homes_moveis_position (nome, id_moveis_user, x, y, z, h, codigo_mundo, id_movel_user) VALUES(@nome, @id_moveis_user, @x, @y, @z, @h, @codigo_mundo, @id_movel_user)')
vRP.prepare('vRP/delPositionMoveis','DELETE FROM monkey_homes_moveis_position WHERE id = @id')
vRP.prepare('vRP/getPositionMoveisAproximacao','select * FROM monkey_homes_moveis_position WHERE nome = @nome and x between @x - 0.2 and @x + 0.2  and y between @y - 0.2 and @y + 0.2  and z between @z - 3.0 and @z + 3.0')


function emP.getFurnitures(id, apto)
    local source = source
    local user_id = vRP.getUserId(source)

    local home = vRP.query("vRP/getHomesById", {id = id})
    local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})
    
    local moveis = vRP.query("vRP/getFunitures")

    local retorno = {}

    retorno.moveis = moveis
    retorno.ownerId = homeDetails[1].user_id
    retorno.idPlayer = user_id
    retorno.authorizedPersons = {}

    local persons = vRP.query("vRP/getAuthorizedPersons", {apto = apto, nome = home[1].nome})
    
    for k,v in pairs(persons) do
        local infoPlayer = vRP.getInformation(v.user_id)
        local person = {}

        person.id = v.user_id
        person.name = infoPlayer[1].name.." "..infoPlayer[1].name2
        person.phone = infoPlayer[1].phone

        table.insert(retorno.authorizedPersons, person)
    end

    return retorno
end

function emP.getMyFurnitures(id, apto)
    local source = source
    local user_id = vRP.getUserId(source)

    local home = vRP.query("vRP/getHomesById", {id = id})
    local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})

    local meusMoveis = vRP.query("vRP/getFunituresUser", { user_id = user_id })
    
    local retorno = {}

    retorno.moveis = meusMoveis
    retorno.ownerId = homeDetails[1].user_id
    retorno.idPlayer = user_id
    retorno.authorizedPersons = {}

    local persons = vRP.query("vRP/getAuthorizedPersons", {apto = apto, nome = home[1].nome})
    
    for k,v in pairs(persons) do
        local infoPlayer = vRP.getInformation(v.user_id)
        local person = {}

        person.id = v.user_id
        person.name = infoPlayer[1].name.." "..infoPlayer[1].name2
        person.phone = infoPlayer[1].phone

        table.insert(retorno.authorizedPersons, person)
    end

    return retorno
end

function emP.buyFurniture(id, type)
    local source = source
	local user_id = vRP.getUserId(source)

    local row = vRP.query("vRP/getFurniturebyId", {id = id})

    if type == "Dinheiro" then
        if vRP.paymentBank(user_id,parseInt(row[1].preco)) then
            vRP.execute("vRP/addFurnitureUser", {nome = row[1].nome, nome_vitrine = row[1].nome_vitrine, url_foto = row[1].url_foto, user_id = user_id, correcao_z = row[1].correcao_z})
            return "sucesso"
        else
            return "erro"
        end
    elseif type == "Coins" then
        if vRP.remGmsId(user_id,parseInt(row[1].coins)) then
            vRP.execute("vRP/addFurnitureUser", {nome = row[1].nome, nome_vitrine = row[1].nome_vitrine, url_foto = row[1].url_foto, user_id = user_id, correcao_z = row[1].correcao_z})
            return "sucesso"
        else
            return "erro"
        end
    end
end

function emP.sellFurniture(id)
    local source = source
	local user_id = vRP.getUserId(source)

    local row = vRP.query("vRP/getFunituresUserbyId", {id = id})
    local furniture = vRP.query("vRP/getFunituresbyName", {nome = row[1].nome})

    vRP.execute("vRP/delFurnitureUser", {id = id})
    vRP.addBank(user_id,(furniture[1].preco * config.porcentagemVendaMovel))
end


function getMoveisMundo(mundo)

    if objetos[mundo] then 
        mundos_moveis[mundo] = false
    else 
        objetos[mundo] = {}
        objetos[mundo].home = vRP.query("vRP/getPositionMoveis", {codigo_mundo = mundo})
        mundos_moveis[mundo] = true
    end

    return objetos[mundo].home, mundos_moveis[mundo]
end

function emP.getObjetoBancoRemover(nome, x , y, z)
    local linhas = vRP.query("vRP/getPositionMoveisAproximacao", { nome = nome, x = x , y = y, z = z})
    return linhas
end

function emP.setUsedFurniture(id, usado)
    local source = source
	local user_id = vRP.getUserId(source)

    if usado then 
        local row = vRP.query("vRP/getPositionMoveisbyID", {id = id})

        if row[1] then 
            local mundo_temp = GetPlayerRoutingBucket(source)
            local aplicationObject, mHash, coords, headObject, objeto = vCLIENT.objectCoords(source,row[1].nome, row[1].correcao_z)
    
            if aplicationObject then 
                vRP.execute('vRP/addPositionMoveis',{ nome = row[1].nome, id_moveis_user = user_id, x = coords.x, y = coords.y, z = coords.z, h = headObject, codigo_mundo = mundo_temp, id_movel_user = row[1].id })
                vRP.execute("vRP/attUsedFurniture", {id = id, usado = usado})
        
                TriggerClientEvent("Notify",source,"amarelo","Inserido com sucesso",5000)

                objetos[mundo_temp] = {}
                objetos[mundo_temp].home  = vRP.query("vRP/getPositionMoveis", {codigo_mundo = mundo_temp})
            end
        end
    else

        local rows = vRP.query('vRP/getPositionMoveisbyID_Movel', {id_movel_user = id})
        local mundo_temp = GetPlayerRoutingBucket(source)

        if rows[1] then 

  
            if parseInt(rows[1].codigo_mundo) == parseInt(mundo_temp) then
                vCLIENT.deletar_movel(source,rows[1].nome, rows[1].x, rows[1].y, rows[1].z)

                vRP.execute("vRP/delPositionMoveis", { id = rows[1].id })
                vRP.execute("vRP/attUsedFurniture", {id = id, usado = false })

                objetos[mundo_temp] = {}
                objetos[mundo_temp].home  = vRP.query("vRP/getPositionMoveis", {codigo_mundo = mundo_temp})

                TriggerClientEvent("Notify",source,"amarelo","Removido com sucesso",5000)
            else 
                TriggerClientEvent("Notify",source,"amarelo","Você precisa estar dentro da casa que o móvel foi colocado para remove-lo",20000)
            end
        end

    end

end

function emP.InserirMovelHash(nome, url_foto) 
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, "Admin") then 
        local nomeV = vRP.prompt(source,'Nome vitrine?', '')
        local precoMoney = vRP.prompt(source,'Preço do movel em Monkey?', '')
        local precoCoin = vRP.prompt(source,'Preço do movel em Coin?', '')
    
        vRP.execute('vRP/addMoveisLoja', { nome = nome, nome_vitrine = nomeV, url_foto = url_foto, preco = precoMoney, coins =  precoCoin})   
        
        TriggerClientEvent("Notify",source,"amarelo","Adicionado com sucesso com sucesso",10000)

    else
        TriggerClientEvent("Notify",source,"vermelho","Acesso Negado",10000)
    end

    
end


function carregarCasas()
    local source = source
    local user_id = vRP.getUserId(source)
    local rows = vRP.query('vRP/get_homes')

    -- local homes = {}

    if #rows > 0 then
        for k,v in pairs(rows) do

            local cds = json.decode(v.cds)
            
            v.x = cds.x
            v.y = cds.y
            v.z = cds.z
        end
    end
        
    return rows
end

function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k, v in pairs(o) do
			if type(k) ~= 'number' then k = '"' .. k .. '"' end
			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end
    
-------------------------------------------------------------------------------------------------
--[ SAI DA CASA E VOLTA PRA REALITY ]------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.leaveHome()
    local source = source
    local user_id = vRP.getUserId(source)
    local rows = vRP.query('vRP/get_home_user_is', { user_id = user_id })
    if #rows > 0 then
        local world = rows[1].world
        local casa = rows[1].nome
        local rows = vRP.query('vRP/get_homes')
        if #rows > 0 then
            for k,v in pairs(rows) do
                if casa == v.nome then
                    local cds = json.decode(v.cds)
                    TriggerClientEvent('emCasa:xyz',source)
                    vRPclient.teleport(source,cds.x,cds.y,cds.z)
                    vRP.execute('vRP/remove_session', {
                        ['user_id'] = user_id,
                        ["world"] = world,
                        ["nome"] = v.nome
                    }) 
                    changeSession(user_id,0)
                end
            end
        end
    end                
end
-------------------------------------------------------------------------------------------------
--[ LISTA DAS CASAS DO PLAYER ]------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.casasPlayer()
    local source = source
    local user_id = vRP.getUserId(source)
    local casas_user = vRP.query('vRP/gethas_home', { user_id = user_id })
    if #casas_user > 0 then
        local casas_player = {}
        for k,v in pairs(casas_user) do
            if v.apartamento ~= -1 then
                table.insert(casas_player, v.nome.."["..v.apartamento.."]")
            else
                table.insert(casas_player, v.nome)
            end
        end
        casas_player = table.concat(casas_player, ", ")
        TriggerClientEvent("Notify",source,"importante","Imóveis possuídos "..casas_player..".", 20000)
    end               
end
-------------------------------------------------------------------------------------------------
--[ MOSTRA AS CASAS E AP's NO MAPA ]-------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.listHome()
    local source = source
    local user_id = vRP.getUserId(source)
    local rows = vRP.query('vRP/get_homes')
    TriggerClientEvent('Notify',source,'importante','Aguarde enquanto localizamos os imóveis à venda.',15000)
    if #rows > 0 then
        for k,v in pairs(rows) do
            if v.disponivel > 0 then
                table.insert(blipHomes,{ nome = v.nome, cds = json.decode(v.cds), tipo = v.apartamento })
            end
        end
    end         
    if #blipHomes > 0 then
        TriggerClientEvent('Notify',source,'sucesso','Imóveis localizados e marcados no seu GPS.',15000) 
        vCLIENT.setBlipsHomes(source,blipHomes)
        blipHomes = {}
    else
        TriggerClientEvent('Notify',source,'negado','Não foi localizado nenhum imóvel à venda.',15000)    
    end
end
-------------------------------------------------------------------------------------------------
--[ CRIAR NOVA CASA ]----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.createHome(x,y,z)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.request(source,"Deseja criar um imóvel nesse local?",30) then
            local rows = vRP.query('vRP/get_homes')
            if #rows > 0 then
                for k,v in pairs(rows) do
                    local cds = json.decode(v.cds)
                    local distance = dist(x,y,z,cds.x,cds.y,cds.z)
                    if distance < 5 then
                        TriggerClientEvent('Notify',source,'negado','Já existe um imóvel nesse local.',15000)  
                        return
                    end
                end
            end

            local interior = vRP.prompt(source,'Qual vai ser o pacote desse imóvel?', '')
            if interior == '' or interior == nil then
                TriggerClientEvent('Notify',source,'negado','Você precisa informar um pacote.',15000)
                return
            else
                for k,v in pairs(config.upgrades) do
                    if interior == k then
                        local nome = vRP.prompt(source,'Qual vai ser o nome desse imóvel?', '')
                        if nome == '' or nome == nil then
                            TriggerClientEvent('Notify',source,'negado','Você precisa informar um nome.',15000)
                            return
                        else
                            if #rows > 0 then
                                for k,v in pairs(rows) do
                                    if v.nome == nome then
                                        TriggerClientEvent('Notify',source,'negado','Já existe um imóvel com esse nome.',15000)  
                                        return
                                    end  
                                end
                            end
                            local apartamento = tonumber(sanitizeString(vRP.prompt(source,"Digite a quantidade de apartamentos ou 0 caso for uma casa:",""),"\"[]{}+=?!_()#@%/\\|,.",false))	
                            if apartamento == '' or apartamento == nil then
                                TriggerClientEvent('Notify',source,'negado','Você precisa informar algo.',15000)
                                return
                            else
                                local valor = tonumber(sanitizeString(vRP.prompt(source,"Digite o valor de venda do imóvel:",""),"\"[]{}+=?!_()#@%/\\|,.",false))	
                                if valor == '' or valor == nil or valor == 0 then
                                    TriggerClientEvent('Notify',source,'negado','Você precisa informar um valor válido.')
                                    return
                                else
                                    local coins = tonumber(sanitizeString(vRP.prompt(source,"Digite o valor de venda do imóvel em coins:",""),"\"[]{}+=?!_()#@%/\\|,.",false))	
                                    if coins == '' or coins == nil then
                                        TriggerClientEvent('Notify',source,'negado','Você precisa informar algo.',15000)
                                        return
                                    else
                                        local porta_fora = { ['x'] = x, ['y'] = y, ['z'] = z }

                                        if not (apartamento > 0)  then
                                            apartamento = -1
                                            disponivel = 1
                                        else
                                            disponivel = apartamento
                                        end

                                        vRP.execute('vRP/insert_home', {
                                            ['interior'] = interior,
                                            ["bau"] = config.upgrades[interior].init_bau,
                                            ["apartamento"] = apartamento,
                                            ["cds"] = json.encode(porta_fora),
                                            ['nome'] = nome,
                                            ['valor'] = valor,
                                            ['qtd_chaves'] = config.upgrades[interior].init_chaves,
                                            ['disponivel'] = disponivel,
                                            ['coins'] = coins,
                                            ['foto'] = config.homes[config.upgrades[interior].casas[1].i].foto
                                        })

                                        TriggerClientEvent('monkey_homes:attCasas',-1, carregarCasas())
                                        TriggerClientEvent('Notify',source,'sucesso','Imóvel criado.',15000)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
                TriggerClientEvent('Notify',source,'negado','Você precisa informar um pacote válido.',15000)  
            end
        end
    end
end
-------------------------------------------------------------------------------------------------
--[ CHECK PERMISSION ]---------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.checkPermission(perm)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        return vRP.hasPermission(user_id,perm)
    end
end
-------------------------------------------------------------------------------------------------
--[ CHECK PERMISSION HOME ]----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function checkPermissionHome(user_id,nome,apartamento)
    if user_id then
        local rows = vRP.query('vRP/get_homes')
        if #rows > 0 then
            for k,v in pairs(rows) do
                if nome == v.nome then
                    if v.apartamento ~= -1 then
                        local rows = vRP.query('vRP/get_homes_permission', { nome = nome, apartamento = apartamento })
                        if #rows > 0 then
                            for k,v in pairs(rows) do
                                if v.user_id == user_id then
                                    return true
                                -- else
                                --     return false
                                end
                            end
                        end
                    else
                        local rows = vRP.query('vRP/get_homes_permission', { nome = nome, apartamento = -1 })
                        if #rows > 0 then
                            for k,v in pairs(rows) do
                                if v.user_id == user_id then
                                    return true
                                -- else
                                --     return false
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
-------------------------------------------------------------------------------------------------
--[ VERIFICA VENCIMENTO IPTU DA CASA ]-----------------------------------------------------------
-------------------------------------------------------------------------------------------------
function verificaIPTUCasa(user_id,nome)
	local rows = vRP.query("vRP/get_iptu",{ user_id = user_id, nome = nome, apartamento = -1 })
	if #rows > 0 then
		if parseInt(rows[1].iptu - os.time()) <= 0 then
            if parseInt(rows[1].expire_home - os.time()) <= 0 then
                TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Você não pagou o IPTU em tempo e perdeu o seu imóvel '"..nome.."'.",8000)
                vRP.execute('vRP/remove_home', {
                    ['user_id'] = user_id,
                    ['nome'] = nome,
                    ['apartamento'] = -1                                          
                })
                vRP.execute('vRP/remove_all_perm', {
                    ["nome"] = nome,
                    ["apartamento"] = -1
                }) 
                local detalhes_casa = vRP.query('vRP/get_homes_data', {nome = nome})
                vRP.execute('vRP/update_disp', {
                    ['disponivel'] = detalhes_casa[1].disponivel + 1,
                    ['nome'] = nome
                })
                return false
            else
                TriggerClientEvent("Notify",vRP.getUserSource(user_id),"negado","Seu IPTU está atrasado, em "..parseInt((rows[1].expire_home - os.time()) / (24*60*60)).." dias você irá perder o seu imóvel '"..nome.."'.",8000)
                return false
            end
        elseif parseInt((rows[1].iptu - os.time()) / (24*60*60)) <= 5 then
            TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam pouquíssimos dias para o seu IPTU do imóvel '"..nome.."' vencer, ATENÇÃO!",8000)
            return true
        elseif parseInt((rows[1].iptu - os.time()) / (24*60*60)) <= 10 then
            TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam poucos dias para o seu IPTU do imóvel '"..nome.."' vencer, ATENÇÃO!",8000)
            return true
        else
            return true
		end
    else
        return false
	end
end
-------------------------------------------------------------------------------------------------
--[ VERIFICA VENCIMENTO IPTU DO AP ]-------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function verificaIPTUAP(user_id,nome,apartamento)
	local rows = vRP.query("vRP/get_iptu",{ user_id = user_id, nome = nome, apartamento = apartamento })
	if #rows > 0 then
		if parseInt(rows[1].iptu - os.time()) <= 0 then
            if parseInt(rows[1].expire_home - os.time()) <= 0 then
                TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Você não pagou o IPTU em tempo e perdeu o seu apartamento ["..apartamento.."] no imóvel '"..nome.."'.",8000)
                vRP.execute('vRP/remove_home', {
                    ['user_id'] = user_id,
                    ['nome'] = nome,
                    ['apartamento'] = apartamento                                         
                })
                vRP.execute('vRP/remove_all_perm', {
                    ["nome"] = nome,
                    ["apartamento"] = apartamento
                }) 
                local detalhes_casa = vRP.query('vRP/get_homes_data', {nome = nome})
                vRP.execute('vRP/update_disp', {
                    ['disponivel'] = detalhes_casa[1].disponivel + 1,
                    ['nome'] = nome
                })
                return false
            else
                TriggerClientEvent("Notify",vRP.getUserSource(user_id),"negado","Seu IPTU está atrasado, em "..parseInt((rows[1].expire_home - os.time()) / (24*60*60)).." dias você irá perder o seu apartamento ["..apartamento.."] no imóvel '"..nome.."'.",8000)
                return false
            end
        elseif parseInt((rows[1].iptu - os.time()) / (24*60*60)) <= 5 then
            TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam pouquíssimos dias para o seu IPTU do apartamento ["..apartamento.."] no imóvel '"..nome.."' vencer, ATENÇÃO!",8000)
            return true
        elseif parseInt((rows[1].iptu - os.time()) / (24*60*60)) <= 10 then
            TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam poucos dias para o seu IPTU do apartamento ["..apartamento.."] no imóvel '"..nome.."' vencer, ATENÇÃO!",8000)
            return true
        else
            return true
		end
    else
        return false
	end
end
-------------------------------------------------------------------------------------------------
--[ SPAWN DO PLAYER ]----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    local casas_user = vRP.query('vRP/gethas_home', { user_id = user_id })
    if #casas_user > 0 then
        for k,v in pairs(casas_user) do
            local detalhes_casa = vRP.query('vRP/get_homes_data', {nome = v.nome})
            local cds = json.decode(detalhes_casa[1].cds)
            vCLIENT.setBlipsOwner(source,detalhes_casa[1].nome,cds)
        end
    end

	local rows = vRP.query("vRP/get_temp_session",{ user_id = user_id })
    local casa_estava = rows

	if rows ~= nil and #rows > 0 then
        local homeidcasa = vRP.query("vRP/getHomesByName", {nome = rows[1].nome})
        local idCasa = homeidcasa[1].id
        local apto = rows[1].apartamento

		if rows[1].apartamento ~= -1 then
            local rows2 = vRP.query('vRP/get_home_details', {nome = rows[1].nome, apartamento = rows[1].apartamento})
            local interior = rows2[1].interior
            if #rows2 > 0 then
                if rows2[1].user_id == user_id then
                    if verificaIPTUAP(user_id,rows[1].nome,rows[1].apartamento) then
                        local ap_active = vRP.query('vRP/get_someone_INDAHOUSE', { nome = rows[1].nome, apartamento = rows[1].apartamento })
                        local cds_home = config.homes[rows[1].interior].porta_dentro
                        if #ap_active > 0 then
                            vRP.execute('vRP/insert_session', {
                                ['user_id'] = user_id,
                                ["world"] = ap_active[1].world,
                                ["interior"] = ap_active[1].interior,
                                ["apartamento"] = casa_estava[1].apartamento,
                                ['nome'] = ap_active[1].nome
                            })
                            vRP.execute('vRP/remove_temp_session', {
                                ['user_id'] = user_id
                            })
                            TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                            vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                            changeSession(user_id,ap_active[1].world)
                            attCoords(source, interior, idCasa, apto)
                        else  
                            local rows = vRP.query('vRP/get_sessions_active_by_interior', { interior = rows[1].interior })
                            if #rows > 0 then
                                last_world_available = 0
                                repeat
                                    for k,v in pairs(rows) do
                                        if v.world == last_world_available then
                                            igual = true
                                        end
                                    end
                
                                    if not igual then
                                        vRP.execute('vRP/insert_session', {
                                            ['user_id'] = user_id,
                                            ["world"] = last_world_available,
                                            ["interior"] = casa_estava[1].interior,
                                            ["apartamento"] = casa_estava[1].apartamento,
                                            ['nome'] = casa_estava[1].nome
                                        })
                                        vRP.execute('vRP/remove_temp_session', {
                                            ['user_id'] = user_id
                                        })
                                        TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                                        vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                                        changeSession(user_id,last_world_available)
                                        attCoords(source, interior, idCasa, apto)
                                        setado = true
                                    end
                
                                    igual = false
                                    last_world_available = last_world_available + 1
                                until setado == true
                                setado = false
                            else
                                vRP.execute('vRP/insert_session', {
                                    ['user_id'] = user_id,
                                    ["world"] = 0,
                                    ["interior"] = casa_estava[1].interior,
                                    ["apartamento"] = casa_estava[1].apartamento,
                                    ['nome'] = casa_estava[1].nome
                                })
                                vRP.execute('vRP/remove_temp_session', {
                                    ['user_id'] = user_id
                                })
                                TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                                vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                                changeSession(user_id,0)
                                attCoords(source, interior, idCasa, apto)
                                setado = true
                            end     
                        end
                    else
                        local rows = vRP.query("vRP/get_iptu",{ user_id = user_id, nome = nome, apartamento = apartamento })
                        if #rows == 0 then
                            local casa = rows[1].nome
                            local rows = vRP.query('vRP/get_homes')
                            if #rows > 0 then
                                for k,v in pairs(rows) do
                                    if casa == v.nome then
                                        local cds = json.decode(v.cds)
                                        vRPclient.teleport(source,cds.x,cds.y,cds.z)
                                        vRP.execute('vRP/remove_temp_session', {
                                            ['user_id'] = user_id
                                        })
                                        attCoords(source, interior, idCasa, apto)
                                    end
                                end
                            end
                        end
                    end
                else
                    local casa = rows[1].nome
                    local rows = vRP.query('vRP/get_homes')
                    if #rows > 0 then
                        for k,v in pairs(rows) do
                            if casa == v.nome then
                                local cds = json.decode(v.cds)
                                vRPclient.teleport(source,cds.x,cds.y,cds.z)
                                vRP.execute('vRP/remove_temp_session', {
                                    ['user_id'] = user_id
                                })
                                attCoords(source, interior, idCasa, apto)
                            end
                        end
                    end
                end
            end
        else
            local rows2 = vRP.query('vRP/get_home_details', {nome = rows[1].nome, apartamento = -1})
            local interior = rows2[1].interior
            if #rows2 > 0 then
                if rows2[1].user_id == user_id then
                    if verificaIPTUCasa(user_id,rows[1].nome) then
                        local house_active = vRP.query('vRP/get_someone_INDAHOUSE', { nome = rows[1].nome, apartamento = -1 })
                        local cds_home = config.homes[rows[1].interior].porta_dentro
                        if #house_active > 0 then
                            vRP.execute('vRP/insert_session', {
                                ['user_id'] = user_id,
                                ["world"] = house_active[1].world,
                                ["interior"] = house_active[1].interior,
                                ["apartamento"] = -1,
                                ['nome'] = house_active[1].nome
                            })
                            vRP.execute('vRP/remove_temp_session', {
                                ['user_id'] = user_id
                            })
                            TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                            vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                            changeSession(user_id,house_active[1].world)
                            attCoords(source, interior, idCasa, apto)
                        else  
                            local rows = vRP.query('vRP/get_sessions_active_by_interior', { interior = rows[1].interior })
                            if #rows > 0 then
                                last_world_available = 0       
                                repeat
                                    for k,v in pairs(rows) do
                                        if v.world == last_world_available then
                                            igual = true
                                        end
                                    end
                
                                    if not igual then
                                        vRP.execute('vRP/insert_session', {
                                            ['user_id'] = user_id,
                                            ["world"] = last_world_available,
                                            ["interior"] = casa_estava[1].interior,
                                            ["apartamento"] = -1,
                                            ['nome'] = casa_estava[1].nome
                                        })
                                        vRP.execute('vRP/remove_temp_session', {
                                            ['user_id'] = user_id
                                        })
                                        TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                                        vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                                        changeSession(user_id,last_world_available)
                                        attCoords(source, interior, idCasa, apto)
                                        setado = true
                                    end
                
                                    igual = false
                                    last_world_available = last_world_available + 1
                                until setado == true
                                setado = false
                            else
                                vRP.execute('vRP/insert_session', {
                                    ['user_id'] = user_id,
                                    ["world"] = 0,
                                    ["interior"] = casa_estava[1].interior,
                                    ["apartamento"] = -1,
                                    ['nome'] = casa_estava[1].nome
                                })
                                vRP.execute('vRP/remove_temp_session', {
                                    ['user_id'] = user_id
                                })
                                TriggerClientEvent('emCasa:xyz',source,cds_home.x,cds_home.y,cds_home.z)
                                vRPclient.teleport(source,cds_home.x,cds_home.y,cds_home.z)
                                changeSession(user_id,0)
                                attCoords(source, interior, idCasa, apto)
                            end                            
                        end
                    else
                        local rows = vRP.query("vRP/get_iptu",{ user_id = user_id, nome = nome, apartamento = -1 })
                        if #rows == 0 then
                            local casa = rows[1].nome
                            local rows = vRP.query('vRP/get_homes')
                            if #rows > 0 then
                                for k,v in pairs(rows) do
                                    if casa == v.nome then
                                        local cds = json.decode(v.cds)
                                        vRPclient.teleport(source,cds.x,cds.y,cds.z)
                                        vRP.execute('vRP/remove_temp_session', {
                                            ['user_id'] = user_id
                                        })
                                        attCoords(source, interior, idCasa, apto)
                                    end
                                end
                            end
                        end
                    end 
                else
                    local casa = rows[1].nome
                    local rows = vRP.query('vRP/get_homes')
                    if #rows > 0 then
                        for k,v in pairs(rows) do
                            if casa == v.nome then
                                local cds = json.decode(v.cds)
                                vRPclient.teleport(source,cds.x,cds.y,cds.z)
                                vRP.execute('vRP/remove_temp_session', {
                                    ['user_id'] = user_id
                                })
                                attCoords(source, interior, idCasa, apto)
                            end
                        end
                    end
                end
            end
        end
    else
        local rows = vRP.query('vRP/gethas_home', { user_id = user_id })
        if #rows > 0 then
            for k,v in pairs(rows) do
                if v.apartamento ~= -1 then
                    verificaIPTUAP(user_id,rows[1].nome,rows[1].apartamento)
                else
                    verificaIPTUCasa(user_id,rows[1].nome)
                end
            end
        end
	end
end)

function attCoords(source, interior, idCasa, apto)
    local cds_home = config.homes[interior].porta_dentro
    local cds_painel = config.homes[interior].painel
    local cds_bau = config.homes[interior].bau
    vCLIENT.attCoords(source, cds_home.x,cds_home.y,cds_home.z, cds_painel.x, cds_painel.y, cds_painel.z, cds_bau.x, cds_bau.y, cds_bau.z, idCasa, apto)
end
-------------------------------------------------------------------------------------------------
--[ PLAYER SAIR DA CIDADE ]----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id and source then
        local rows = vRP.query('vRP/get_home_user_is', { user_id = user_id })
        if #rows > 0 then
            vRP.execute("vRP/insert_temp_session",{ user_id = user_id, interior = rows[1].interior, nome = rows[1].nome, apartamento = rows[1].apartamento }) 
            vRP.execute('vRP/remove_session', {
                ['user_id'] = user_id,
                ["world"] = rows[1].world,
                ["nome"] = rows[1].nome
            }) 
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.setNetwork(homeName)
	local source = source

	if networkHouses[homeName] == nil then
		networkHouses[homeName] = {}
	end

	networkHouses[homeName][source] = source
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVENETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.removeNetwork(homeName)
	local source = source
	networkHouses[homeName][source] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.getNetwork(homeName)
	return networkHouses[homeName]
end
-------------------------------------------------------------------------------------------------
--[ RETORNA PESO BAÚ DO IMÓVEL ]-----------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function getBau(user_id)
    if user_id then
        local rows = vRP.query('vRP/get_home_user_is', { user_id = user_id })
        if #rows > 0 then
            local homes = vRP.query('vRP/get_homes')
            for k,v in pairs(homes) do
                if v.nome == rows[1].nome then 
                    return v.bau
                end
            end
        end
	end
    return 50
end
local noStore = {
	["pizza"] = true,
	["water"] = true,
	["coffee"] = true,
	["hamburger"] = true,
	["cola"] = true,
	["donut"] = true,
	["hotdog"] = true,
	["dirtywater"] = true
}

-------------------------------------------------------------------------------------------------
--[ DISTÂNCIA ]----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function dist ( x1, y1, z1, x2, y2, z2 )
	local dx = x1 - x2
	local dy = y1 - y2
	local dz = z1 - z2
	return math.sqrt ( dx * dx + dy * dy + dz*dz )
end
-------------------------------------------------------------------------------------------------
--[ MUDA A SESSÃO ]------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function changeSession(user_id,session)
    if user_id then
        SetPlayerRoutingBucket(vRP.getUserSource(user_id),session)
	end
end

-------------------------------------------------------------------------------------------------
--[ CALCULA OS DIAS ]----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function calculaDias (qdias)
	local stimer = parseInt(os.time()+(24*qdias*60*60))
	
	return stimer	
end



-----------------
---   CHEST   ---
-----------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local chestOpen = {}
local chestOpenWeigth = {}

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.chestClose()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if chestOpen[user_id] then
			chestOpen[user_id] = nil
		end
        if chestOpenWeigth[user_id] then
			chestOpenWeigth[user_id] = nil
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINTPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkIntPermissions(idCasa)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(parseInt(user_id)) then
			return false
		end

        local home = vRP.query("vRP/getHomesById", {id = idCasa})
        chestOpen[user_id] = home[1].nome..home[1].apartamento
        chestOpenWeigth[user_id] = home[1].bau
        return true
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.openChest(id, apto)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local myinventory = {}
		local mychestopen = {}
		local mychestname = chestOpen[parseInt(user_id)]
		if mychestname ~= nil then

			local players = vRPclient.nearestPlayers(source,5)
			for k,v in pairs(players) do
				vCLIENT.chestClose(k)
			end

			local inv = vRP.getInventory(parseInt(user_id))
			if inv then
				for k,v in pairs(inv) do
					if string.sub(v.item,1,9) == "toolboxes" then
						local advFile = LoadResourceFile("logsystem","toolboxes.json")
						local advDecode = json.decode(advFile)

						v.durability = advDecode[v.item]
					end

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.desc = vRP.itemDescList(v.item)
					v.tipo = vRP.itemTipoList(v.item)
					v.unity = vRP.itemUnityList(v.item)
					v.economy = vRP.itemEconomyList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.key = v.item
					v.slot = k

					myinventory[k] = v
				end
			end

			local data = vRP.getSData("chest:"..mychestname)
			local sdata = json.decode(data) or {}
			if data then
				for k,v in pairs(sdata) do
					table.insert(mychestopen,{desc = vRP.itemDescList(k), unity = vRP.itemUnityList(k), tipo = vRP.itemTipoList(k), economy = vRP.itemEconomyList(k),amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, peso = vRP.itemWeightList(k) })
				end
			end
			-- local consult = vRP.query("vRP/getExistChest",{ name = mychestname })
			-- if consult[1].name == mychestname then
            local home = vRP.query("vRP/getHomesById", {id = id})
            local homeDetails = vRP.query('vRP/get_home_details', {nome = home[1].nome, apartamento = apto})

            return myinventory,mychestopen,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),vRP.computeChestWeight(sdata),parseInt(homeDetails[1].bau),{ identity.name.." "..identity.name2,parseInt(user_id),identity.phone,identity.registration,vRP.getBank(user_id) }
			-- end
		end
	end
	return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("monkey_home_chest:updateSlot")
AddEventHandler("monkey_home_chest:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end
		end

		TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("monkey_home_chest:sumSlot")
AddEventHandler("monkey_home_chest:sumSlot",function(itemName,slot,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(slot)].item == itemName then
				if vRP.tryChestItem(user_id,"chest:"..tostring(chestOpen[parseInt(user_id)]),itemName,amount,slot,"chest") then
					TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.storeItem(itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if noStore[itemName] or vRP.itemSubTypeList(itemName) then
				TriggerClientEvent("Notify",source,"amarelo","Você não pode armazenar este item em baús.",5000)
                TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
				return
			end
			-- local consult = vRP.query("vRP/getExistChest",{ name = tostring(chestOpen[parseInt(user_id)]) })
			-- if consult[1].name == tostring(chestOpen[parseInt(user_id)]) then
            if vRP.storeChestItem(user_id,"chest:"..tostring(chestOpen[parseInt(user_id)]),itemName,amount,parseInt(chestOpenWeigth[user_id]),slot,"chest") then
                TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
            end
			-- end
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("monkey_home_chest:populateSlot")
AddEventHandler("monkey_home_chest:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.takeItem(itemName,slot,amount)
	if itemName then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.tryChestItem(user_id,"chest:"..tostring(chestOpen[parseInt(user_id)]),itemName,amount,slot,"chest") then
				TriggerClientEvent("monkey_home_chest:Update",source,"updateChest")
			end
		end
	end
end

Citizen.CreateThread(function()
    vRP.execute("vRP/lockHouses")
end)

Citizen.CreateThread(function()
    while true do
        local casas = vRP.query("vRP/getHousesUsers")

        for k,v in pairs(casas) do
            local user_id = v.user_id
            
            if parseInt(v.iptu - os.time()) <= 0 then
                if parseInt(v.expire_home - os.time()) <= 0 then
                    if vRP.getUserSource(user_id) ~= nil then
                        TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Você não pagou o IPTU em tempo e perdeu o seu imóvel '"..v.nome.."'.",8000)
                    end
                    vRP.execute('vRP/remove_home', {
                        ['user_id'] = user_id,
                        ['nome'] = v.nome,
                        ['apartamento'] = -1                                          
                    })
                    vRP.execute('vRP/remove_all_perm', {
                        ["nome"] = v.nome,
                        ["apartamento"] = -1
                    })
                    local detalhes_casa = vRP.query('vRP/get_homes_data', {nome = v.nome})
                    vRP.execute('vRP/update_disp', {
                        ['disponivel'] = detalhes_casa[1].disponivel + 1,
                        ['nome'] = v.nome
                    })
                else
                    TriggerClientEvent("Notify",vRP.getUserSource(user_id),"negado","Seu IPTU está atrasado, em "..parseInt((rows[1].expire_home - os.time()) / (24*60*60)).." dias você irá perder o seu imóvel nº"..v.id..".",8000)
                end
            elseif parseInt((v.iptu - os.time()) / (24*60*60) <= 5) then
                if vRP.getUserSource(user_id) ~= nil then
                    TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam pouquíssimos dias para o seu IPTU do imóvel nº"..v.id.." expirar, ATENÇÃO!",8000)
                end
            elseif parseInt((v.iptu - os.time()) / (24*60*60) <= 10) then
                if vRP.getUserSource(user_id) ~= nil then
                    TriggerClientEvent("Notify",vRP.getUserSource(user_id),"aviso","Faltam poucos dias para o seu IPTU do imóvel nº"..v.id.." expirar, ATENÇÃO!",8000)
                end
            end

            Citizen.Wait(250)
        end

        Citizen.Wait(30*60000)
    end
end)

function emP.setCoordBau(id, apto, x, y, z)
    local home = vRP.query("vRP/getHomesById", {id = id})

    vRP.execute("vRP/attCoordBau", { coord = json.encode({x = x, y = y, z = z}), nome = home[1].nome, apto = apto})
    TriggerClientEvent("Notify",source,"sucesso","Coordenada alterada", 5000)
end

function emP.setCoordPainel(id, apto, x, y, z)
    local home = vRP.query("vRP/getHomesById", {id = id})

    vRP.execute("vRP/attCoordPainel", { coord = json.encode({x = x, y = y, z = z}), nome = home[1].nome, apto = apto})
    TriggerClientEvent("Notify",source,"sucesso","Coordenada alterada", 5000)
end


RegisterCommand('dropMovelAdd',function(source, args, rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"Admin") then
       vCLIENT.objectCoords(source,args[1], 0)
    end 
end)

RegisterCommand('dropMovelRem',function(source, args, rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vRP.hasPermission(user_id,"Admin") then
        
       vCLIENT.remDropMoveis(source)
    end 
end)
