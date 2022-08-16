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



local blipe = {
    [1] = {['x'] = -142.89300537109, ['y'] = -559.16772460938, ['z'] = 48.228996276855, ['grau'] = 337.48379516602}
}

local i = 1
local blip_temp = false
local mostrarBlip = true


Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - vector3(blipe[i].x, blipe[i].y, blipe[i].z))
        if distance < 10 then
            if mostrarBlip then
                DrawMarker(0, blipe[i].x, blipe[i].y, blipe[i].z, 0, 0, 0, 0, 0, 0, 1.00, 1.00, 1.00, 255, 217, 2, 100, 0, 0, 0, 0)
                if distance < 2 then
                draw3dtext(blipe[i].x, blipe[i].y, blipe[i].z, "Clique ~r~Aqui~w~ para remover o Blip")
                    if IsControlJustPressed(0, 38) then
                        mostrarBlip = false
                    end
                end
            end
            
            
            time = 1 -- pra melhorar o desempenho na renderização
        end
        Wait(time)
    end
end)

-- Registra um comando
RegisterCommand('setbliptrue',function(source, args) -- COMANDO DE ADMIN PARA RESETAR PERSONAGEM
    mostrarBlip = true
end)


-- Registra um Evento no Client que tanto o Server como o próprio Client' pode chamar
RegisterNetEvent('aula07:pagamento')
AddEventHandler('aula07:pagamento', function(valor, texto)


    print("Valor: "..valor)
    print("casa: "..texto)

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
