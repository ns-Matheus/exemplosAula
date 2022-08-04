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
Tunnel.bindInterface("Aula03", cRP)
vSERVER = Tunnel.getInterface("Aula03")



local blip = {
    [1] = {['x'] = -320.64813232422, ['y'] = -389.73776245117, ['z'] = 30.137336730957, ['grau'] = 84.393211364746, ['muda']= false },
    [2] = {['x'] = -325.37512207031, ['y'] = -389.16720581055, ['z'] = 30.155345916748, ['grau'] = 82.770965576172, ['muda']= false},
    [3] = {['x'] = -329.07345581055, ['y'] = -388.79592895508, ['z'] = 30.168676376343, ['grau'] = 80.570030212402, ['muda']= false},
    [4] = {['x'] = -332.72018432617, ['y'] = -388.26342773438, ['z'] = 30.202442169189, ['grau'] = 82.407897949219, ['muda']= false},
    [5] = {['x'] = -337.4245300293, ['y'] = -387.64608764648, ['z'] = 30.199325561523, ['grau'] = 82.460670471191, ['muda']= false},
    [6] = {['x'] = -342.13311767578, ['y'] = -387.05892944336, ['z'] = 30.33836555481, ['grau'] = 83.305725097656, ['muda']= false},
    [7] = {['x'] = -347.67178344727, ['y'] = -386.4006652832, ['z'] = 30.484655380249, ['grau'] = 80.780830383301, ['muda']= false},
    [8] = {['x'] = -353.12167358398, ['y'] = -385.64282226563, ['z'] = 30.647937774658, ['grau'] = 82.207260131836, ['muda']= false},
    [9] = {['x'] = -358.62841796875, ['y'] = -385.0539855957, ['z'] = 30.810417175293, ['grau'] = 81.278823852539, ['muda']= false},
    [10] = {['x'] = -365.9889831543, ['y'] = -384.09527587891, ['z'] = 31.044847488403, ['grau'] = 82.331184387207, ['muda']= false}
}

local i = 1

Citizen.CreateThread(function()
    while true do   
        local time = 1000   
        local ped = PlayerPedId()    
        local coords = GetEntityCoords(ped) 
            local distance = #(coords - vector3(blip[i].x,blip[i].y,blip[i].z))  
            if distance < 20 then  
                DrawMarker(2, blip[i].x,blip[i].y,blip[i].z,0,0,0,0,0,0,1.53,0.77,0.89,255,232,58,100,0,0,0,1)
                time = 1
                if distance < 1.2 then 
                    if IsControlJustPressed(0, 38) then
                        i = i + 1
                        if i == 10 then
                            i = 1   
                        end
                    end
                end
            end
        Wait(time)
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