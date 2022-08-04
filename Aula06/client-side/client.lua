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
Tunnel.bindInterface("Aula06", cRP)
vSERVER = Tunnel.getInterface("Aula06")



local blipe = {
    [1] = { ['x'] = -222.7300567627, ['y'] = -534.79437255859, ['z'] = 34.727737426758, ['grau'] = 157.14070129395 },
    [2] = { ['x'] = -242.19082641602, ['y'] = -585.61090087891, ['z'] = 33.859436035156, ['grau'] = 159.16525268555 },
    [3] = { ['x'] = -440.79959106445, ['y'] = -654.91247558594, ['z'] = 30.794322967529, ['grau'] = 89.996887207031 },
    [4] = { ['x'] = -547.89129638672, ['y'] = -707.28125, ['z'] = 32.841533660889, ['grau'] = 202.85517883301 },
    [5] = { ['x'] = -503.47436523438, ['y'] = -828.18182373047, ['z'] = 30.015336990356, ['grau'] = 180.77893066406 },
    [6] = { ['x'] = -365.09759521484, ['y'] = -850.30328369141, ['z'] = 31.147523880005, ['grau'] = 262.71270751953 },
    [7] = { ['x'] = -246.37010192871, ['y'] = -745.90258789063, ['z'] = 32.700778961182, ['grau'] = 334.19561767578 },
    [8] = { ['x'] = -106.66725921631, ['y'] = -690.11120605469, ['z'] = 34.926700592041, ['grau'] = 106.27382659912 },
    [9] = { ['x'] = 6.6161479949951, ['y'] = -299.70181274414, ['z'] = 46.58618927002, ['grau'] = 9.4891424179077 }
}

local i = 1
local blip_temp = false


Citizen.CreateThread(function()
    while true do
        local time = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local distance = #(coords - vector3(blipe[i].x, blipe[i].y, blipe[i].z))
        if distance < 40 then
            DrawMarker(0, blipe[i].x, blipe[i].y, blipe[i].z, 0, 0, 0, 0, 0, 0, 1.00, 1.00, 1.00, 255, 217, 2, 100, 0, 0
                , 0, 0)
            time = 1
            if distance < 5 then
                if IsControlJustPressed(0, 38) then
                    if  IsPedInAnyVehicle(ped) then
                        local vehicle = GetPlayersLastVehicle()
                        if IsVehicleModel(vehicle, GetHashKey("akuma")) then -- verifica se o player está no veículo
                            i = i + 1
                            if DoesBlipExist(blip_temp) then
                                RemoveBlip(blip_temp)
                                blip_temp = nil
                            end
                            if i == #blipe then
                                i = 1
                            end
                            blip_temp = CriandoBlip(blipe[i].x, blipe[i].y, blipe[i].z, "Destino")
                            TriggerServerEvent('aula06:item_recebido', 100, "dollars2")
                        else
                            TriggerEvent("Notify","vermelho","Você não está em uma Akuma.", 5000)
                        end
                    end
                end
            end
        end
        Wait(time)
    end
end)

-- Registra um comando
RegisterCommand('entraremservico',function(source, args) -- COMANDO DE ADMIN PARA RESETAR PERSONAGEM

end)




-- Registra um Evento no Client que tanto o Server como o próprio Client' pode chamar
RegisterNetEvent('aula06:pagamento')
AddEventHandler('aula06:pagamento', function(valor, texto)


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
