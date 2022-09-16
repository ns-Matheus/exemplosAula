local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_outfit", cnVRP)
vSERVER = Tunnel.getInterface("monkey_outfit")

local outfits
local debug = false

-- RegisterCommands

RegisterCommand('createoutfitmonkey', function(source, args, rawCommand)

    local temPermissao = vSERVER.verificarPermissao('owner')

    if temPermissao then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local masculino = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
        vSERVER.criarOutfit({ x = coords[1], y = coords[2], z = coords[3], masculino = masculino })
        cnVRP.CarregarBlips()
    else
        vSERVER.chamarNotificar('Sem permissão')
    end

end)

RegisterCommand('createoutfitmonkeyinit', function(source, args, rawCommand)

    local temPermissao = vSERVER.verificarPermissao('Admin')

    if temPermissao then
        local ped = PlayerPedId()
        local masculino = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
        vSERVER.criarOutfitinit({ masculino = masculino })

    else
        vSERVER.chamarNotificar('Sem permissão')
    end

end)

RegisterNetEvent("aplicaroutfitmonkeyinit")
AddEventHandler("aplicaroutfitmonkeyinit", function()
    local ped = PlayerPedId()
    local masculino = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
    vSERVER.aplicarOutfitInit(masculino)
end)


RegisterCommand('createoutfitmonkeyprisao', function(source, args, rawCommand)

    local temPermissao = vSERVER.verificarPermissao('Admin')

    if temPermissao then
        local ped = PlayerPedId()
        local masculino = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
        vSERVER.criarOutfitPrisao({ masculino = masculino })

    else
        vSERVER.chamarNotificar('Sem permissão')
    end

end)

RegisterNetEvent("aplicaroutfitmonkeyprisao")
AddEventHandler("aplicaroutfitmonkeyprisao", function()
    local ped = PlayerPedId()
    local masculino = GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")
    vSERVER.aplicarOutfitPrisao(masculino)
end)


RegisterCommand('debugoutfitmonkey', function(source, args, rawCommand)
    debug = not debug
end)

RegisterCommand('deletaroutfitmonkey', function(source, args, rawCommand)
    vSERVER.deletaroutfitmonkey(args[1])
    cnVRP.CarregarBlips()
end)




-- Threads

Citizen.CreateThread(function()

    cnVRP.CarregarBlips()

    while true do
        local time = 500
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for key, value in pairs(outfits) do
            local distance = #
                (
                vector3(coords[1], coords[2], coords[3]) -
                    vector3(parseInt(value.x), parseInt(value.y), parseInt(value.z)))
            if distance < 10 then
                if debug then
                    DrawText3D(value.x + 0.0, value.y + 0.0, value.z + 0.0,
                        string.upper(value.id ..
                            " - " .. value.nome .. (value.masculino == true and " (Masculino)" or " (Feminino)")), 255,
                        255, 255)
                end
                DrawMarker(23, value.x + 0.0, value.y + 0.0, value.z - 0.95, 0, 0, 0, 0, 0, 0, 1.00, 1.00, 1.00, 0, 191,
                    143, 100, 0, 0, 0, 0)
                time = 1
                if distance < 1.2 then
                    drawTxt("PRESSIONE  ~r~E~w~  PARA SELECIONAR UM MODELO DE ROUPA", 4, 0.5, 0.93, 0.50, 255, 255, 255,
                        180)
                    if IsControlJustPressed(1, 38) then
                        local k = value.id
                        if vSERVER.verificarPermissao(value.permissao) then
                            retorno = vSERVER.listaOutfit(k)
                            -- print(lista[1].nomeOutfit)

                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            show = true,
                            id = value.id,
                            lista = retorno.listaOutfit,
                            permissoes = retorno.permissoes
                        })


                        -- local model = GetEntityModel(ped)
                        -- if value.masculino == true then
                        --     if model == GetHashKey("mp_m_freemode_01") then
                        --          vSERVER.salvarClotesOutfit(value.id)
                        --     end
                        -- else
                        --     if model == GetHashKey("mp_f_freemode_01") then
                        --        vSERVER.salvarClotesOutfit(value.id)
                        --    end
                        -- end
                        --TriggerEvent("monkey:setClothingOutFit",json.encode(value.roupa))
                        --TriggerClientEvent("updateRoupas",source,result)
                        -- else
                        --     vSERVER.chamarNotificar('Sem permissão')
                        end
                    end
                end

            end

        end
        Citizen.Wait(time)

    end
end)


RegisterNUICallback("sair", function(data, cb)
    show = false
    SetNuiFocus(false, false)
    cb(show)
end)

RegisterNUICallback("aplicarOutfit", function(data,cb)
    local idAplicar = data.outfitCard_id
    vSERVER.salvarClotesOutfit(idAplicar)
end)

RegisterNUICallback("delOutfitCard", function(data, cb)
    local id_Card = data.outfitCard_id
    local deleteBlip = vSERVER.deletarOutfitCard(id_Card)
    cb(deleteBlip)
end)

RegisterNUICallback("addOutfit", function(data,cb)
    local id = data.outfit_id
    local nome = data.outfit_nome
    local lista = vSERVER.AdicionarOutfit(id, nome) 
    cb(lista)
end)

RegisterNUICallback("delOutfitBlip", function(data, cb)
    local id = data.outfit_id
    vSERVER.deletarOutfitBlip(id)
end)




-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function cnVRP.CarregarBlips()
    outfits = vSERVER.CarregarBlips()
end

function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.35 * scale)
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
        DrawText(_x, _y)
    end
end
