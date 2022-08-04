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
Tunnel.bindInterface("sn-Matheus", cRP)
vSERVER = Tunnel.getInterface("sn-Matheus")



local locais = {
    [1] = { ['x'] = -248.65843200684, ['y'] = -350.91201782227, ['z'] = 29.951997756958, ['grau'] = 100.44073486328 }
}



Citizen.CreateThread(function()
    while true do   -- Loop infinito enquanto for true
        local time = 1000   -- velocidade do blip/neste caso milisegundos
        local ped = PlayerPedId()    -- pega Id do player
        local coords = GetEntityCoords(ped)  -- pega a coordenada do player
        for k, v in pairs(locais) do
            local distance = #(coords - vector3(v.x,v.y,v.z))   -- calcula coordenada - o valor da varia X
            if distance < 10 then   -- Verifica a distancia caso seja menor que 10 metros aparecerá o blip caso contrário não
                DrawMarker(25, v.x, v.y, v.z - 0.98,0,0,0,0,0,0,0.57,0.52,1.30,255,0,0,100,0,0,0,0)
                time = 1
                if distance < 2 then -- se a distancia for entre 2 metros ativa a funcao de IsControlJustPressed
                    draw3dtext(v.x, v.y, v.z, "Pressione ~r~E~w~")
                    if IsControlJustPressed(0, 38) then
                        SetNuiFocus(true,true)
                        SendNUIMessage({ action = true})
                    end
                end
            end
        end
        Wait(time)
    end
end)

-- Função para retornar a tela sempre com parametro data
RegisterNUICallback("fechar",function(data) 
    SetNuiFocus(false,false)
end)




-- Função Main, sempre importa-la ao se utilizar a função Draw3dtext
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
