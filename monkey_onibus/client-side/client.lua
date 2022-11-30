local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),cnVRP)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local blips = nil
local selected = 0
local inService_geral = false
local inService_onibus_metropolitano = false
local inService_taxi = false
local inService_taxi_metropolitano = false
local buscar_passageiros = false

local passagerios = {
    [0] = { ['p'] = nil },
    [1] = { ['p'] = nil },
    [2] = { ['p'] = nil },
    [3] = { ['p'] = nil },
}

local idLoc = nil
local pedlist = Config.PedList
local locs_geral = nil
local locs_taxi = nil

RegisterCommand("porta",function(source,args,rawCommand)
    local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
    SetVehicleDoorOpen(vehicle,0,0,0)
    SetVehicleDoorOpen(vehicle,1,0,0)
    SetVehicleDoorOpen(vehicle,2,0,0)
    SetVehicleDoorOpen(vehicle,3,0,0)
end)

RegisterCommand("portaFecha",function(source,args,rawCommand)
    local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(ped)
    SetVehicleDoorsShut(vehicle, false);
end)

RegisterCommand("iniciar_onibus",function(source,args,rawCommand)
    idLoc = 1

    iniciarOnibusMetropolitano()
end)

--ONIBUS
Citizen.CreateThread(function()
	while true do
        local tempo = 1000
		if inService_onibus_metropolitano then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
            local coords = GetEntityCoords(ped)
            local distance = #(coords - vector3(locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3] ))
			if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey("bus")) then
                tempo = 5
                if not Config.usar_monkey_marker then
                    DrawMarker(21,locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
                end
				
                if distance <= 2.5 then
					if IsControlJustPressed(0,38) then
						RemoveBlip(blips)
						SetVehicleIndicatorLights(vehicle, 0, true)
						SetVehicleIndicatorLights(vehicle, 1, true)
                        -- SetVehicleDoorOpen(vehicle,0,0,0)
						-- SetVehicleDoorOpen(vehicle,1,0,0)
						-- SetVehicleDoorOpen(vehicle,2,0,0)
						-- SetVehicleDoorOpen(vehicle,3,0,0)
                        Wait(1000)
                        FreezeEntityPosition(vehicle, true)

                        for k,value in pairs(passagerios) do 
                            if value.p then

                                local random_passagerio_desce = math.random(10)

                                if random_passagerio_desce <= 5 then 
                                    
                                    if DoesEntityExist(value.p) then
                                        SetBlockingOfNonTemporaryEvents(value.p,true)
                                        
                                        Citizen.Wait(500)
                                        --TaskLeaveVehicle(value.p,vehicle,262144)
                                        TaskLeaveVehicle(value.p,vehicle,1)
                                        TaskWanderStandard(value.p,10.0,10)
                                        setar_nil_passageiro(k) 
                                        Citizen.Wait(1000)
                                    end
                                end
                            end
                        end

                        Citizen.Wait(2000)

                        local random_passagerio_sobe = math.random(1,2)
                        local x = 0
                      
                        while x < random_passagerio_sobe do 
                            for k,value in pairs(passagerios) do 
                                if value.p == nil then
                                    local pmodel = math.random(#pedlist)
                                    modelRequest(pedlist[pmodel].Model)
                                    passagerios[k].p = CreatePed(4,pedlist[pmodel].Hash,locs_geral[selected].CoordsPed[1], locs_geral[selected].CoordsPed[2], locs_geral[selected].CoordsPed[3],3374176,true,false)
                                    SetBlockingOfNonTemporaryEvents(passagerios[k].p,true)
                                    SetEntityInvincible(passagerios[k].p, true)

                                    TaskEnterVehicle(passagerios[k].p,vehicle,-1,parseInt(k),2.0,1,0)
                                    
                                    SetEntityAsMissionEntity(passagerios[k].p,true,true)
                                    SetModelAsNoLongerNeeded(pedlist[pmodel].Hash)
                                    Citizen.Wait(2500)
                                    break
                                end
                            end

                            x = x + 1
                        end

                        
						if selected == #locs_geral then
                            selected = 1
						else
							selected = selected + 1
						end
                        FreezeEntityPosition(vehicle, false)
                        -- SetVehicleDoorsShut(vehicle, false);
                        Wait(2000)
                        
                        -- SetVehicleDoorShut(vehicle,0,0)
						-- SetVehicleDoorShut(vehicle,1,0)
						-- SetVehicleDoorShut(vehicle,2,0)
						-- SetVehicleDoorShut(vehicle,3,0)
						SetVehicleIndicatorLights(vehicle, 0, false)
						SetVehicleIndicatorLights(vehicle, 1, false)

						blipCreating(locs_geral, selected)

                        vSERVER.payment(math.random(locs_geral.Payment[1],locs_geral.Payment[2]), idLoc)
					end
				end
			end
		end
        Citizen.Wait(tempo)
	end
end)

--TAXI
Citizen.CreateThread(function()
	while true do
        local tempo = 1000
		if inService_taxi_metropolitano then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
            local coords = GetEntityCoords(ped)
            local distance = #(coords - vector3(locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3] ))
			if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey("taxi")) then
                tempo = 5
                if not Config.usar_monkey_marker then
                    DrawMarker(21,locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
                end
				
                if distance <= 2.5 then
					if IsControlJustPressed(0,38) then
						RemoveBlip(blips)
						SetVehicleIndicatorLights(vehicle, 0, true)
						SetVehicleIndicatorLights(vehicle, 1, true)
                        -- SetVehicleDoorOpen(vehicle,0,0,0)
						-- SetVehicleDoorOpen(vehicle,1,0,0)
						-- SetVehicleDoorOpen(vehicle,2,0,0)
						-- SetVehicleDoorOpen(vehicle,3,0,0)
                        Wait(1000)
                        FreezeEntityPosition(vehicle, true)

                        for k,value in pairs(passagerios) do 
                            if value.p then

                                local random_passagerio_desce = math.random(10)

                                if random_passagerio_desce <= 5 then 
                                    
                                    if DoesEntityExist(value.p) then
                                        SetBlockingOfNonTemporaryEvents(value.p,true)
                                        
                                        Citizen.Wait(500)
                                        --TaskLeaveVehicle(value.p,vehicle,262144)
                                        TaskLeaveVehicle(value.p,vehicle,1)
                                        TaskWanderStandard(value.p,10.0,10)
                                        setar_nil_passageiro(k) 
                                        Citizen.Wait(1000)
                                    end
                                end
                            end
                        end

                        Citizen.Wait(2000)

                        local random_passagerio_sobe = math.random(1,2)
                        local x = 0
                      
                        while x < random_passagerio_sobe do 
                            for k,value in pairs(passagerios) do 
                                if value.p == nil then
                                    local pmodel = math.random(#pedlist)
                                    modelRequest(pedlist[pmodel].Model)
                                    passagerios[k].p = CreatePed(4,pedlist[pmodel].Hash,locs_geral[selected].CoordsPed[1], locs_geral[selected].CoordsPed[2], locs_geral[selected].CoordsPed[3],3374176,true,false)
                                    SetBlockingOfNonTemporaryEvents(passagerios[k].p,true)
                                    SetEntityInvincible(passagerios[k].p, true)

                                    TaskEnterVehicle(passagerios[k].p,vehicle,-1,parseInt(k),2.0,1,0)
                                    
                                    SetEntityAsMissionEntity(passagerios[k].p,true,true)
                                    SetModelAsNoLongerNeeded(pedlist[pmodel].Hash)
                                    Citizen.Wait(2500)
                                    break
                                end
                            end

                            x = x + 1
                        end

                        
						if selected == #locs_geral then
                            selected = 1
						else
							selected = selected + 1
						end
                        FreezeEntityPosition(vehicle, false)
                        -- SetVehicleDoorsShut(vehicle, false);
                        Wait(2000)
                        
                        -- SetVehicleDoorShut(vehicle,0,0)
						-- SetVehicleDoorShut(vehicle,1,0)
						-- SetVehicleDoorShut(vehicle,2,0)
						-- SetVehicleDoorShut(vehicle,3,0)
						SetVehicleIndicatorLights(vehicle, 0, false)
						SetVehicleIndicatorLights(vehicle, 1, false)

						blipCreating(locs_geral, selected)

                        vSERVER.payment(math.random(locs_geral.Payment[1],locs_geral.Payment[2]), idLoc)
					end
				end
			end
		end
        Citizen.Wait(tempo)
	end
end)


--Iniciar serviço Geral
Citizen.CreateThread(function()
	while true do
        local tempo = 1000
		if inService_geral then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
            local coords = GetEntityCoords(ped)

            if buscar_passageiros then
                local distance = #(coords - vector3(locs_geral.init[selected].Coords[1], locs_geral.init[selected].Coords[2], locs_geral.init[selected].Coords[3]))
                if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey(locs_geral.car)) then
                    tempo = 5
                    if not Config.usar_monkey_marker then
                        DrawMarker(21,locs_geral.init[selected].Coords[1], locs_geral.init[selected].Coords[2], locs_geral.init[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
                    end
                    if distance <= 2.5 then
                        if IsControlJustPressed(0,38) then
                            RemoveBlip(blips)
                            SetVehicleIndicatorLights(vehicle, 0, true)
                            SetVehicleIndicatorLights(vehicle, 1, true)
                            Wait(1000)
                            FreezeEntityPosition(vehicle, true)

                            Citizen.Wait(2000)

                            local random_passagerio_sobe = math.random(1,2)
                            local x = 0
                        
                            while x < random_passagerio_sobe do 
                                for k,value in pairs(passagerios) do 
                                    if value.p == nil then
                                        local pmodel = math.random(#pedlist)
                                        modelRequest(pedlist[pmodel].Model)
                                        passagerios[k].p = CreatePed(4,pedlist[pmodel].Hash,locs_geral.init[selected].CoordsPed[1], locs_geral.init[selected].CoordsPed[2], locs_geral.init[selected].CoordsPed[3],3374176,true,false)
                                        SetBlockingOfNonTemporaryEvents(passagerios[k].p,true)
                                        SetEntityInvincible(passagerios[k].p, true)

                                        TaskEnterVehicle(passagerios[k].p,vehicle,-1,parseInt(k),2.0,1,0)
                                        
                                        SetEntityAsMissionEntity(passagerios[k].p,true,true)
                                        SetModelAsNoLongerNeeded(pedlist[pmodel].Hash)
                                        Citizen.Wait(2500)
                                        break
                                    end
                                end

                                x = x + 1
                            end

                            if selected == #locs_geral.init then
                                buscar_passageiros = false
                                selected = 1
                                blipCreating(locs_geral.trilha, selected)
                            else
                                selected = selected + 1
                                blipCreating(locs_geral.init, selected)
                            end
                            FreezeEntityPosition(vehicle, false)
                            Wait(2000)

                            SetVehicleIndicatorLights(vehicle, 0, false)
                            SetVehicleIndicatorLights(vehicle, 1, false)
                        end
                    end
                end
            else
                local distance = #(coords - vector3(locs_geral.trilha[selected].Coords[1], locs_geral.trilha[selected].Coords[2], locs_geral.trilha[selected].Coords[3] ))
                if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey(locs_geral.car)) then
                    tempo = 5
                    if not Config.usar_monkey_marker then
                        DrawMarker(21,locs_geral.trilha[selected].Coords[1], locs_geral.trilha[selected].Coords[2], locs_geral.trilha[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
                    end
                    if distance <= 2.5 then
                        if IsControlJustPressed(0,38) then
                            RemoveBlip(blips)
                            SetVehicleIndicatorLights(vehicle, 0, true)
                            SetVehicleIndicatorLights(vehicle, 1, true)
                            Wait(1000)
                            FreezeEntityPosition(vehicle, true)

                            Citizen.Wait(2000)

                            if selected == #locs_geral.trilha then
                                buscar_passageiros = true

                                for k,value in pairs(passagerios) do 
                                    if value.p then
                                        if DoesEntityExist(value.p) then
                                            SetBlockingOfNonTemporaryEvents(value.p,true)
                                            
                                            Citizen.Wait(500)
                                            --TaskLeaveVehicle(value.p,vehicle,262144)
                                            TaskLeaveVehicle(value.p,vehicle,1)
                                            TaskWanderStandard(value.p,10.0,10)
                                            setar_nil_passageiro(k) 
                                            Citizen.Wait(1000)
                                        end
                                    end
                                end

                                selected = 1
                                blipCreating(locs_geral.init, selected)

                                vSERVER.payment(math.random(locs_geral.Payment[1],locs_geral.Payment[2]), idLoc)
                            else
                                selected = selected + 1
                                blipCreating(locs_geral.trilha, selected)
                            end
                            FreezeEntityPosition(vehicle, false)
                            Wait(2000)

                            SetVehicleIndicatorLights(vehicle, 0, false)
                            SetVehicleIndicatorLights(vehicle, 1, false)

                            -- vSERVER.payment(math.random(Config.Payment[1],Config.Payment[2]))
                        end
                    end
                end
            end
		end
        Citizen.Wait(tempo)
	end
end)

--TAXI
-- Citizen.CreateThread(function()
-- 	while true do
--         local tempo = 1000
-- 		if inService_taxi then
-- 			local ped = PlayerPedId()
-- 			local vehicle = GetVehiclePedIsUsing(ped)
--             local coords = GetEntityCoords(ped)

--             if buscar_passageiros then
--                 local distance = #(coords - vector3(locs_geral.init[selected].Coords[1], locs_geral.init[selected].Coords[2], locs_geral.init[selected].Coords[3]))
--                 if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey(locs_geral.car)) then
--                     tempo = 5
--                     if not Config.usar_monkey_marker then
--                         DrawMarker(21,locs_geral.init[selected].Coords[1], locs_geral.init[selected].Coords[2], locs_geral.init[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
--                     end
--                     if distance <= 2.5 then
--                         if IsControlJustPressed(0,38) then
--                             RemoveBlip(blips)
--                             SetVehicleIndicatorLights(vehicle, 0, true)
--                             SetVehicleIndicatorLights(vehicle, 1, true)
--                             Wait(1000)
--                             FreezeEntityPosition(vehicle, true)

--                             Citizen.Wait(2000)

--                             local random_passagerio_sobe = math.random(1,2)
--                             local x = 0
                        
--                             while x < random_passagerio_sobe do 
--                                 for k,value in pairs(passagerios) do 
--                                     if value.p == nil then
--                                         local pmodel = math.random(#pedlist)
--                                         modelRequest(pedlist[pmodel].Model)
--                                         passagerios[k].p = CreatePed(4,pedlist[pmodel].Hash,locs_geral.init[selected].CoordsPed[1], locs_geral.init[selected].CoordsPed[2], locs_geral.init[selected].CoordsPed[3],3374176,true,false)
--                                         SetBlockingOfNonTemporaryEvents(passagerios[k].p,true)
--                                         SetEntityInvincible(passagerios[k].p, true)

--                                         TaskEnterVehicle(passagerios[k].p,vehicle,-1,parseInt(k),2.0,1,0)
                                        
--                                         SetEntityAsMissionEntity(passagerios[k].p,true,true)
--                                         SetModelAsNoLongerNeeded(pedlist[pmodel].Hash)
--                                         Citizen.Wait(2500)
--                                         break
--                                     end
--                                 end

--                                 x = x + 1
--                             end

--                             if selected == #locs_geral.init then
--                                 buscar_passageiros = false
--                                 selected = 1
--                                 blipCreating(locs_geral.trilha, selected)
--                             else
--                                 selected = selected + 1
--                                 blipCreating(locs_geral.init, selected)
--                             end
--                             FreezeEntityPosition(vehicle, false)
--                             Wait(2000)

--                             SetVehicleIndicatorLights(vehicle, 0, false)
--                             SetVehicleIndicatorLights(vehicle, 1, false)
--                         end
--                     end
--                 end
--             else
--                 local distance = #(coords - vector3(locs_geral.trilha[selected].Coords[1], locs_geral.trilha[selected].Coords[2], locs_geral.trilha[selected].Coords[3] ))
--                 if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey(locs_geral.car)) then
--                     tempo = 5
--                     if not Config.usar_monkey_marker then
--                         DrawMarker(21,locs_geral.trilha[selected].Coords[1], locs_geral.trilha[selected].Coords[2], locs_geral.trilha[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
--                     end
--                     if distance <= 2.5 then
--                         if IsControlJustPressed(0,38) then
--                             RemoveBlip(blips)
--                             SetVehicleIndicatorLights(vehicle, 0, true)
--                             SetVehicleIndicatorLights(vehicle, 1, true)
--                             Wait(1000)
--                             FreezeEntityPosition(vehicle, true)

--                             Citizen.Wait(2000)

--                             if selected == #locs_geral.trilha then
--                                 buscar_passageiros = true

--                                 for k,value in pairs(passagerios) do 
--                                     if value.p then
--                                         if DoesEntityExist(value.p) then
--                                             SetBlockingOfNonTemporaryEvents(value.p,true)
                                            
--                                             Citizen.Wait(500)
--                                             --TaskLeaveVehicle(value.p,vehicle,262144)
--                                             TaskLeaveVehicle(value.p,vehicle,1)
--                                             TaskWanderStandard(value.p,10.0,10)
--                                             setar_nil_passageiro(k) 
--                                             Citizen.Wait(1000)
--                                         end
--                                     end
--                                 end

--                                 selected = 1
--                                 blipCreating(locs_geral.init, selected)

--                                 vSERVER.payment(math.random(locs_geral.Payment[1],locs_geral.Payment[2]), idLoc)
--                             else
--                                 selected = selected + 1
--                                 blipCreating(locs_geral.trilha, selected)
--                             end
--                             FreezeEntityPosition(vehicle, false)
--                             Wait(2000)

--                             SetVehicleIndicatorLights(vehicle, 0, false)
--                             SetVehicleIndicatorLights(vehicle, 1, false)

--                             -- vSERVER.payment(math.random(Config.Payment[1],Config.Payment[2]))
--                         end
--                     end
--                 end
--             end
-- 		end
--         Citizen.Wait(tempo)
-- 	end
-- end)

function setar_nil_passageiro(indice) 
    Citizen.CreateThread(function()
        Citizen.Wait(5000)
        passagerios[indice].p = nil
    end)
end

--------------------------------------------------------------------------------
-- Sair do serviço
--------------------------------------------------------------------------------

--ONIBUS
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if inService_onibus_metropolitano or inService_geral then
			timeDistance = 5

			drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EXPEDIENTE",4,0.260,0.905,0.5,255,255,255,200)

			if IsControlJustPressed(0,168) then
				TriggerEvent("Notify","importante","Você saiu de serviço")
				RemoveBlip(blips)

                local vehicle = GetVehiclePedIsUsing(ped)
                for k,value in pairs(passagerios) do 
                    if value.p ~= nil then
                        if DoesEntityExist(value.p) then
                            TaskLeaveVehicle(value.p, vehicle, 262144)
                            TaskWanderStandard(value.p, 10.0, 10)
                            Citizen.Wait(1100)
                            
                        end
                    end
                end
				blips = nil
				selected = 0
			
				inService_onibus_metropolitano = false
				inService_geral = false
			end	
		end

		Citizen.Wait(timeDistance)
	end
end)

--TAXI
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if inService_taxi_metropolitano or inService_geral then
			timeDistance = 5

			drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EXPEDIENTE",4,0.260,0.905,0.5,255,255,255,200)

			if IsControlJustPressed(0,168) then
				TriggerEvent("Notify","importante","Você saiu de serviço")
				RemoveBlip(blips)

                local vehicle = GetVehiclePedIsUsing(ped)
                for k,value in pairs(passagerios) do 
                    if value.p ~= nil then
                        if DoesEntityExist(value.p) then
                            TaskLeaveVehicle(value.p, vehicle, 262144)
                            TaskWanderStandard(value.p, 10.0, 10)
                            Citizen.Wait(1100)
                            
                        end
                    end
                end
				blips = nil
				selected = 0
			
				inService_taxi_metropolitano = false
				inService_geral = false
			end	
		end

		Citizen.Wait(timeDistance)
	end
end)

local locs = nil

--MANDA PRA TELA
Citizen.CreateThread(function ()
    locs = vSERVER.getLocs()

    while true do
		local time = 500
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for k, v in pairs(locs) do
            local distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(parseInt(v.x),parseInt(v.y), parseInt(v.z)))
            
            if distance < 10 and inService_geral == false and inService_onibus_metropolitano == false or inService_taxi_metropolitano == false then
                if not Config.usar_monkey_marker then
                    DrawMarker(23,v.x+0.0,v.y+0.0,v.z-0.95,0,0,0,0,0,0,1.00,1.00,1.00,0, 191, 143,100,0,0,0,0)
                    DrawText3Ds(v.x+0.0,v.y+0.0,v.z+0.2, "Transportes", 255, 255, 255)
                end
                time = 1

                if distance < 2.0 then
                    if IsControlJustPressed(1,38) then
                        local loc = vSERVER.getLocId(v.id)

                        SendNUIMessage({ 
                            method = "open",
                            nome = "",
                            idDono = loc[1].idDono,
                            preco = loc[1].preco,
                            valorCaixa = loc[1].valorCaixa,
                            nivel = loc[1].nivel,
                            porcentagemGanho = loc[1].porcentagemGanho,
                            id = loc[1].id,
                            idPlayer = loc[1].idPlayer,
                            namePlayer = loc[1].namePlayer
                        })
                        SetNuiFocus(true,true)
                        -- ExecuteCommand("iniciar_onibus")
                    end
                end
            end
        end
        Citizen.Wait(time)
    end
end)



--------------------------------------------------------------------------------
-- NUICALLBACK
--------------------------------------------------------------------------------

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
    cb("sucesso")
end)

RegisterNUICallback('initRoute', function(data, cb)
    idLoc = data.id

	SetNuiFocus(false, false)
    if(data.nome == "Metropolitano") then
        iniciarOnibusMetropolitano()
    elseif(data.nome == "Taxi") then
        iniciarTaxiMetropolitano()
    else
        iniciarRotas(data.nome)
    end
    cb("sucesso")
end)

RegisterNUICallback('buy', function(data, cb)
    local retorno = nil
    if vSERVER.buy(data.id) then
        retorno = vSERVER.getLocId(data.id)
    else
        retorno = "erro"
    end

    cb(retorno)
end)

RegisterNUICallback('withdraw', function(data, cb)
    local retorno = nil
    if vSERVER.withdraw(data.id, data.valor) then
        retorno = vSERVER.getLocId(data.id)
    else
        retorno = "erro"
    end

    cb(retorno)
end)

RegisterNUICallback('setPorcentagem', function(data, cb)
    vSERVER.setPorcentagem(data.id, data.valor)

    local retorno = vSERVER.getLocId(data.id)

    cb(retorno)
end)
--------------------------------------------------------------------------------
-- NUICALLBACK
--------------------------------------------------------------------------------
--ONIBUS
function iniciarOnibusMetropolitano()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    locs_geral = Config.locs_geral

    if inService_onibus_metropolitano then
        RemoveBlip(blips)
        local vehicle = GetVehiclePedIsUsing(ped)
        for k,value in pairs(passagerios) do 
            if value.p ~= nil then
                if DoesEntityExist(value.p) then
                    TaskLeaveVehicle(value.p, vehicle, 262144)
                    TaskWanderStandard(value.p, 10.0, 10)
                    Citizen.Wait(1100)
                    
                end
            end
        end
        blips = nil
        selected = 0
    
        inService_onibus_metropolitano = false
        TriggerEvent("Notify", "aviso", Config.Notify.Leave)
    else
        inService_onibus_metropolitano = true
        selected = 1
        blipCreatingMetropolitano(locs_geral, selected)
        TriggerEvent("Notify", "sucesso", Config.Notify.Enter) 
    end
end

--TAXI
function iniciarTaxiMetropolitano()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    locs_geral = Config.Locs_taxi

    if inService_taxi_metropolitano then
        RemoveBlip(blips)
        local vehicle = GetVehiclePedIsUsing(ped)
        for k,value in pairs(passagerios) do 
            if value.p ~= nil then
                if DoesEntityExist(value.p) then
                    TaskLeaveVehicle(value.p, vehicle, 262144)
                    TaskWanderStandard(value.p, 10.0, 10)
                    Citizen.Wait(1100)
                    
                end
            end
        end
        blips = nil
        selected = 0
    
        inService_taxi_metropolitano = false
        TriggerEvent("Notify", "aviso", Config.Notify.Leave)
    else
        inService_taxi_metropolitano = true
        selected = 1
        blipCreatingMetropolitano(locs_geral, selected)
        TriggerEvent("Notify", "sucesso", Config.Notify.Enter) 
    end
end

function iniciarRotas(rota)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if rota == "Aventura" then
        locs_geral = Config.Locs_aventura
    elseif rota == "Viagem" then
        locs_geral = Config.Locs_viagem
    elseif rota == "Turismo" then
        locs_geral = Config.Locs_turismo
    elseif rota == "Taxi" then
        locs_geral = Config.Locs_taxi    
    end

    if inService_geral then
        RemoveBlip(blips)
        local vehicle = GetVehiclePedIsUsing(ped)
        for k,value in pairs(passagerios) do 
            if value.p ~= nil then
                if DoesEntityExist(value.p) then
                    TaskLeaveVehicle(value.p, vehicle, 262144)
                    TaskWanderStandard(value.p, 10.0, 10)
                    Citizen.Wait(1100)
                    
                end
            end
        end
        blips = nil
        selected = 0
    
        inService_geral = false
        TriggerEvent("Notify", "aviso", Config.Notify.Leave)
    else
        inService_geral = true
        selected = 1
        buscar_passageiros = true
        blipCreating(locs_geral.init, selected)
        TriggerEvent("Notify", "sucesso", Config.Notify.Enter) 
    end
end


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

function modelRequest(model)
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Citizen.Wait(10)
    end
end

function blipCreatingMetropolitano(locs_geral, selected)
    blips = AddBlipForCoord(locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3])
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 5)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destino")
    EndTextCommandSetBlipName(blips)
end

function blipCreating(locs_geral, selected)
    blips = AddBlipForCoord(locs_geral[selected].Coords[1], locs_geral[selected].Coords[2], locs_geral[selected].Coords[3])
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 5)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Destino")
    EndTextCommandSetBlipName(blips)
end

function DrawText3Ds(x,y,z, text, r,g,b)
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