local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_outfit", cnVRP)
vSERVER = Tunnel.getInterface("monkey_outfit")

local outfits
local debug = false

local id_card_aberto = 0

-- RegisterCommands

RegisterCommand('createoutfitmonkey', function(source, args, rawCommand)

    local temPermissao = vSERVER.verificarPermissaoAdmin()
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

    local temPermissao = vSERVER.verificarPermissaoAdmin()

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

    local temPermissao = vSERVER.verificarPermissaoAdmin()

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
            local distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(value.x, value.y, value.z))
            if distance < 10 then
                if debug then
                    DrawText3D(value.x, value.y, value.z,string.upper(value.id.." - "..value.nome..(value.masculino == true and " (Masculino)" or " (Feminino)")), 255,255, 255)
                end
                --DrawMarker(23, value.x + 0.0, value.y + 0.0, value.z - 0.95, 0, 0, 0, 0, 0, 0, 1.00, 1.00, 1.00, 0, 191,143, 100, 0, 0, 0, 0)
                DrawMarker(21,value.x, value.y, value.z-0.2,0,0,0,0,0,0,0.50,0.50,0.65,2,149,255,100,0,0,0,1)
                
                time = 1
                if distance < 1.2 then
                    if value.masculino == true then
                        drawTxt("PRESSIONE  ~r~E~w~  PARA SELECIONAR UM MODELO DE ROUPA MASCULINO", 4, 0.5, 0.93, 0.50, 255, 255, 255,180)
                    else
                        drawTxt("PRESSIONE  ~r~E~w~  PARA SELECIONAR UM MODELO DE ROUPA FEMININO", 4, 0.5, 0.93, 0.50, 255, 255, 255,180)
                    end

                    if IsControlJustPressed(1, 38) then
                        local k = value.id
                        id_card_aberto = value.id

                        local sexo_e = false

                        if value.masculino == true then
                            local model = GetEntityModel(ped)
                            if model == GetHashKey("mp_m_freemode_01") then
                                sexo_e = true
                            end
                        else 
                            local model = GetEntityModel(ped)
                            if model == GetHashKey("mp_f_freemode_01") then
                                sexo_e = true
                            end
                        end

                        if sexo_e then 
                            if vSERVER.verificarPermissao(value.permissao) then
                                retorno = vSERVER.listaOutfit(k)
    
                                SetNuiFocus(true, true)
                                SendNUIMessage({
                                    show = true,
                                    id = value.id,
                                    lista = retorno.listaOutfit,
                                    permissoes = retorno.permissoes
                                })
                            end

                        end
                        
                    end
                end

            end

        end
        Citizen.Wait(time)

    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- NUISCallBack
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("sair", function(data, cb)
    show = false
    SetNuiFocus(false, false)
    cb(show)
end)

RegisterNUICallback("aplicarOutfit", function(data,cb)
    local idAplicar = data.id_roupa
    vSERVER.aplicarClotesOutfit(idAplicar)
end)

RegisterNUICallback("delOutfitCard", function(data, cb)
    local id_Card = data.outfitCard_id
    vSERVER.deletarOutfitCard(id_Card)
    local r = vSERVER.listaOutfit(id_card_aberto)
    cb(r.listaOutfit)
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
    Wait(250)
    cnVRP.CarregarBlips()
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
