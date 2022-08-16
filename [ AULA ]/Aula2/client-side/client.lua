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
Tunnel.bindInterface("Aula04", cRP)
vSERVER = Tunnel.getInterface("Aula04")



local blip = {
    [1] = { ['x'] = -46.719669342041, ['y'] = -1077.0946044922, ['z'] = 26.736932754517, ['grau'] = 244.78665161133,
        ['muda'] = false },
    [2] = { ['x'] = -47.92130279541, ['y'] = -1079.2966308594, ['z'] = 26.745000839233, ['grau'] = 137.0274810791,
        ['muda'] = false },
    [3] = { ['x'] = -49.646812438965, ['y'] = -1076.9467773438, ['z'] = 26.859722137451, ['grau'] = 75.346138000488,
        ['muda'] = false }
}

local i = 1

Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - vector3(blip[i].x, blip[i].y, blip[i].z))
        if distance < 10 then
            if i == 1 then
                DrawMarker(2, blip[i].x, blip[i].y, blip[i].z, 0, 0, 0, 0, 0, 0, 1.53, 0.77, 0.89, 255, 232, 58, 100, 0,
                    0, 0, 1)
            end
            if i == 2 then
                DrawMarker(2, blip[i].x, blip[i].y, blip[i].z, 0, 0, 0, 0, 0, 0, 1.53, 0.77, 0.89, 255, 255, 255, 100, 0
                    , 0, 0, 1)
            end
            if i == 3 then
                DrawMarker(2, blip[i].x, blip[i].y, blip[i].z, 0, 0, 0, 0, 0, 0, 1.53, 0.77, 0.89, 56, 168, 63, 100, 0, 0
                    , 0, 1)
            end
            time = 1
            if distance < 1.2 then
                draw3dtext(blip[i].x, blip[i].y, blip[i].z, "Clique ~r~Aqui~w~ para remover o Blip")
                if IsControlJustPressed(0, 38) then
                    i = i + 1
                    if i == 4 then
                        i = 1
                    end
                end
            end
        end
        Wait(time)
    end
end)




RegisterCommand("telaMostrar", function(source, args)

    SendNUIMessage({ acao = "telaMostrar", mostrar = true })
    SetNuiFocus(true, true)

end)

RegisterCommand("telaEsconder", function(source, args)

    SendNUIMessage({ acao = "telaEsconder", naoMostrar = false })
    SetNuiFocus(false, false)

end)

--SetNuiFocus(false,false)

RegisterNUICallback("fechar", function(data, cb)

    local h = data.titulo

    print(h)

    cb({ hg = "teste de reotnor sei lá" })

end)























function CriandoBlip(x, y, z, texto)

    local blip_temp = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip_temp, 1)
    SetBlipColour(blip_temp, 5)
    SetBlipScale(blip_temp, 0.4)
    SetBlipAsShortRange(blip_temp, false)
    SetBlipRoute(blip_temp, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(texto)
    EndTextCommandSetBlipName(blip_temp)

    return blip_temp
end


function draw3dtext(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 100)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 300
    DrawRect(_x, _y + 0.0125, 0.01 + factor, 0.03, 0, 0, 0, 100)
end
