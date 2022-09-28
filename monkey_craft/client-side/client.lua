local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_craft",cnVRP)
vSERVER = Tunnel.getInterface("monkey_craft")

local crafts
local lista_craft = {}
-- RegisterCommands

RegisterCommand('createcraftmonkey', function(source, args, rawCommand)
    if vSERVER.isValido() then
        local temPermissao = vSERVER.verificarPermissao(Config.permissaoParaCriar)

        if temPermissao then
            SendNUIMessage({ method = 'openCreateCraft' })
            SetNuiFocus(true, true)
        else
            vSERVER.chamarNotificar('Sem permissão')
        end
    end
end)

-- Threads

Citizen.CreateThread(function ()
    cnVRP.CarregarCrafts()
    while true do
        local time = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for key, value in pairs(crafts) do
            local distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(parseInt(value.x),parseInt(value.y), parseInt(value.z)))
            if distance < 5 then
                DrawText3D(value.x+0.0, value.y+0.0, value.z+0.0, string.upper(value.nome_craft), 255, 255, 255)
                DrawMarker(23,value.x+0.0,value.y+0.0,value.z-0.95,0,0,0,0,0,0,1.00,1.00,1.00,122, 41, 122,100,0,0,0,0)
                time = 1
                if distance < 1.7 then
                    if IsControlJustPressed(1,38) then
                        if vSERVER.isValido() then
                            if vSERVER.verificarPermissao(value.permissao) then
                                if vSERVER.getBucket() == 0 then
                                    SendNUIMessage({
                                        method = 'open',
                                        namePlayer = vSERVER.getInfo(),
                                        id = value.id,
                                        permissions = vSERVER.getPermissions(),
                                        itens = vSERVER.getItens(),
                                        tipo = value.tipo
                                    })
                                    SetNuiFocus(true, true)
                                else
                                    TriggerEvent("Notify", "vermelho", "Não é possivel craftar fora do mundo 0", 10000) 
                                end
                            else
                                vSERVER.chamarNotificar('Sem permissão')
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(time)
    end
end)

-- NUI Callbacks

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('createCraft', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local nome = data.name
    local permissao = data.permission
    local tipo = data.tipo
    vSERVER.createCraft({ x = coords[1], y = coords[2], z = coords[3], permissao = permissao, nome = nome, tipo = tipo })
    cnVRP.CarregarCrafts()
    cb("")
end)

RegisterNUICallback('removeCraft', function(data, cb)
    vSERVER.deleteCraft(data)
    cnVRP.CarregarCrafts()
    cb("")
end)

RegisterNUICallback('getRecipes', function(data, cb)

    local retorno = {}
    local recipes = vSERVER.getRecipes(data)

    for key, value in pairs(recipes) do

        local insumos = vSERVER.getInsumos({id = value.id});

        table.insert(retorno, {
            id = value.id,
            id_craft = value.id_craft,
            nome_item = value.nome_item,
            nomeVitrine = value.nomeVitrine,
            quantidade = value.quantidade,
            insumos = insumos,
            tempo = value.tempo
        })

    end

    cb(retorno)
end)


-- RegisterNUICallback('craftRecipe', function(data, cb)
--     local time = (data.amount * Config.multiplicadorTempoCraft) + Config.tempoCraftar
--     vRP.playAnim(false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
--     TriggerEvent("Progress",time,"Craftando")
--     Citizen.Wait(time)
--     vSERVER.criar(data)
--     vRP.stopAnim(false)

-- end)


RegisterNUICallback('craftDarItem', function(data, cb)
    for k, v in pairs(lista_craft) do
        if v.tempo == 0 then
            vSERVER.darItemPed(v.nome, v.quantidade)
            table.remove(lista_craft, k)
        end
    end
    cb(criar)
end)


RegisterNUICallback('craftRecipe', function(data, cb)
    local show = true
    local criar = vSERVER.removerItemPed(data)
    if criar == 1 then
        local item = {
            ["id"] = data.id,
            ["nome"] = data.item.nome,
            ["tempo"] = data.item.tempo,
            ["quantidade"] = data.item.quantidade
        }
        table.insert(lista_craft, item)
        cb(show)
    end

end)


Citizen.CreateThread(function()
    while true do
        Wait(1000)
        while #lista_craft > 0 do
            for k, v in pairs(lista_craft) do
                if v.tempo > 0 then
                    v.tempo = parseInt(v.tempo) -1
                    SendNUIMessage({
                        tempoReal = v.tempo,
                        v.id
                    })
                end
            end
            Wait(1000)
        end
    end    
end)



RegisterNUICallback('createRecipe', function(data, cb)
    vSERVER.createRecipe(data)
    cb("")
end)

RegisterNUICallback('removeRecipe', function(data, cb)
    vSERVER.removeRecipe(data)
    cb("")
end)

RegisterNUICallback('getInsumos', function(data, cb)
    local rows = vSERVER.getInsumos(data)
    cb(rows)
end)

RegisterNUICallback('createInsumo', function(data, cb)
    vSERVER.createInsumo(data)
    cb("")
end)

RegisterNUICallback('removeInsumo', function(data, cb)
    vSERVER.removeInsumo(data)
    cb("")
end)



-- functions

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function cnVRP.CarregarCrafts()
    crafts = vSERVER.getCraft()
end

RegisterCommand('alterarposcraft', function(source, args, rawCommand)
    local temPermissao = vSERVER.verificarPermissao("Admin")
    if temPermissao then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        vSERVER.alterar({id = args[1], x = coords[1], y = coords[2], z = coords[3]})
        cnVRP.CarregarCrafts()
    end
end)


RegisterNUICallback('comprar_por_coin', function(data, cb)
    
   
    if vSERVER.comprar_por_coin(data) then
        cb({
            titulo = "Parabéns!",
            messsagem = "Comprado com sucesso!",
            tipo = "success"
        })
        
    else
        cb({
            titulo = "ERROR!",
            messsagem = "Não tem coins o suficiente ou já possuei esse craft!",
            tipo = "error"
        })
    end
    
end)

RegisterNUICallback('comprar_por_money', function(data, cb)

    local total_money = 0

    local recipes = vSERVER.getRecipes(data)

    for key, value in pairs(recipes) do
        if value.isMoney then
            total_money = total_money + 1
        end
    end
    
    if total_money < 3 then
        if vSERVER.comprar_por_money(data) then
            cb({
                titulo = "Parabéns!",
                messsagem = "Comprado com sucesso!",
                tipo = "success"
            })
            
        else
            cb({
                titulo = "ERROR!",
                messsagem = "Não tem money o suficiente ou já possuei esse craft!",
                tipo = "error"
            })
        end
    else
        cb({
            titulo = "ERROR!",
            messsagem = "Você já tem 3 crafts comprados por money, pode apenas comprar por coins agora!",
            tipo = "error"
        })

    end
   
   
    
end)