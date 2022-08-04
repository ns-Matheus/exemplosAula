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
Tunnel.bindInterface("Aula02", cRP)
vSERVER = Tunnel.getInterface("Aula02")



local blip = {
    [1] = {['x'] = -321.33139038086, ['y'] = -375.66656494141, ['z'] = 30.160297393799, ['grau'] = 171.76905822754, ['bol'] = false  },
    [2] = {['x'] = -318.79077148438, ['y'] = -376.31362915039, ['z'] = 30.123769760132, ['grau'] = 167.65362548828, ['bol'] = false },
    [3] = {['x'] = -316.06253051758, ['y'] = -376.99395751953, ['z'] = 30.121196746826, ['grau'] = 164.76977539063, ['bol'] = false },
    [4] = {['x'] = -313.18878173828, ['y'] = -377.76409912109, ['z'] = 30.098440170288, ['grau'] = 158.40789794922, ['bol'] = false },
    [5] = {['x'] = -310.56295776367, ['y'] = -378.75100708008, ['z'] = 30.076393127441, ['grau'] = 171.7638092041,  ['bol'] = false }
}



Citizen.CreateThread(function()
    while true do   
        local time = 1000   
        local ped = PlayerPedId()    
        local coords = GetEntityCoords(ped)  
        for k, v in pairs(blip) do
            local distance = #(coords - vector3(v.x,v.y,v.z))   
            if distance < 10 then  
                if v.bol then 
                    DrawMarker(1, v.x, v.y, v.z - 0.98,0,0,0,0,0,0,0.57,0.52,1.30,3,255,0,100,0,0,0,0)
                else
                    DrawMarker(1, v.x, v.y, v.z - 0.98,0,0,0,0,0,0,0.57,0.52,1.30,255,40,40,100,0,0,0,0)
                end
                time = 1
            end
        end
        Wait(time)
    end
end)


local point ={
    [1] = { ['x'] = -315.1360168457, ['y'] = -381.51608276367, ['z'] = 30.112535476685, ['grau'] = 332.40097045898, }
}


Citizen.CreateThread(function()
    while true do   
        local time = 1000   
        local ped = PlayerPedId()    
        local coords = GetEntityCoords(ped)  
        for k, v in pairs(point) do
            local distance = #(coords - vector3(v.x,v.y,v.z))   
            if distance < 10 then  
                DrawMarker(25, v.x, v.y, v.z - 0.98,0,0,0,0,0,0,0.57,0.52,1.30,17,108,54,100,0,0,0,0)
                time = 1
                if distance < 2 then 
                    draw3dtext(v.x, v.y, v.z, "Clique ~g~Aqui~w~")
                    if IsControlJustPressed(0, 38) then
                        SetNuiFocus(true,true)
                        SendNUIMessage({action = true})
                    end
                end
            end
        end
        Wait(time)
    end
end)




RegisterNUICallback("fechar",function(data) 
    SetNuiFocus(false,false)
    for k, v in pairs(blip) do
        if parseInt(data.ChangeColor) == 6 then
            v.bol = true
        else
            v.bol = false
        end
    end

    local ui = data.ChangeColor
    
    if parseInt(data.ChangeColor) < 6 then
        blip[ parseInt(data.ChangeColor) ].bol = true
    end
end)



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