local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local vRP = Proxy.getInterface("vRP")

local oRP = {}
Tunnel.bindInterface(GetCurrentResourceName(),oRP)
local vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local blips = nil
local selected = 0
local inService = false
local passenger = nil
local lastPassenger = nil
local checkPed = true

local locs = RKGConfig.Locs
local pedlist = RKGConfig.PedList

RegisterCommand(RKGConfig.Command,function(source,args,rawCommand)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local distance = #(coords - vector3( RKGConfig.Start.Coords[1],RKGConfig.Start.Coords[2],RKGConfig.Start.Coords[3]))
    if distance <= RKGConfig.Start.Distance then
        if inService then
            RemoveBlip(blips)
			if DoesEntityExist(passenger) then
				TaskLeaveVehicle(passenger, vehicle, 262144)
				TaskWanderStandard(passenger, 10.0, 10)
				Citizen.Wait(1100)
				SetVehicleDoorShut(vehicle, 3, 0)
			end
			blips = nil
			selected = 0
			passenger = nil
			checkPed = true
			inService = false
			TriggerEvent("Notify", "aviso", RKGConfig.Notify.Leave)
        else
            inService = true
            selected = math.random(#locs)
            blipCreating(locs, selected)
            TriggerEvent("Notify", "sucesso", RKGConfig.Notify.Enter) 
        end
    end
end)

local inPed = nil

local locsPed = {
	[1] = { ['x'] = 895.40032958984, ['y'] = -178.35260009766, ['z'] = 74.700263977051, ['grau'] = 234.0 }
}
local pedHashs = {
	"u_m_m_streetart_01"
}

Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		if locsPed[1].ped == nil then
			Citizen.Wait(math.random(5,20))
				
			local mHash = GetHashKey(pedHashs[math.random(#pedHashs)])

			RequestModel(mHash)
			while not HasModelLoaded(mHash) do
				RequestModel(mHash)
				Citizen.Wait(10)
			end

			-- rand = 1

			inPed = CreatePed(4,mHash,locsPed[1].x+0.0,locsPed[1].y+0.0,locsPed[1].z-1,locsPed[1].grau,false,false)
			locsPed[1].ped = inPed
			SetEntityInvincible(inPed,true)
			FreezeEntityPosition(inPed,true)
			SetPedSuffersCriticalHits(inPed,false)
			SetBlockingOfNonTemporaryEvents(inPed,true)
			SetModelAsNoLongerNeeded(mHash)

		end
		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		wait = 1000
		if GetDistanceBetweenCoords(896.39178466797, -178.87466430664, 74.70027923584, GetEntityCoords(ped)) < 5.0 then
			DrawMarker(21,896.39178466797, -178.87466430664, 74.70027923584-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,129,242,248,150,0,0,0,1)
			if GetDistanceBetweenCoords(896.39178466797, -178.87466430664, 74.70027923584, GetEntityCoords(ped)) < 1.0 then
			
				if inService == false then 
					drawTxt("PRESSIONE ~b~E~s~ PARA INICIAR TRABALHO", 4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed (1, 38) then
						local coords = GetEntityCoords(ped)
						local distance = #(coords - vector3( RKGConfig.Start.Coords[1],RKGConfig.Start.Coords[2],RKGConfig.Start.Coords[3]))
						if distance <= RKGConfig.Start.Distance then
							if not inService then
								inService = true
								selected = math.random(#locs)
								blipCreating(locs, selected)
								TriggerEvent("Notify", "sucesso", RKGConfig.Notify.Enter) 
							end
						end
					end
				end

			end

			wait = 5
			
		end
		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if inService then
			timeDistance = 5

			drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EXPEDIENTE",4,0.260,0.905,0.5,255,255,255,200)

			if IsControlJustPressed(0,168) then
				TriggerEvent("Notify","importante","Você saiu de serviço")
				RemoveBlip(blips)
				if DoesEntityExist(passenger) then
					TaskLeaveVehicle(passenger, vehicle, 262144)
					TaskWanderStandard(passenger, 10.0, 10)
					Citizen.Wait(1100)
					SetVehicleDoorShut(vehicle, 3, 0)
				end
				blips = nil
				selected = 0
				passenger = nil
				checkPed = true
				inService = false
			end	
		end

		Citizen.Wait(timeDistance)
	end
end)

Citizen.CreateThread(function()
	while true do
        local rkg = 1000
		if inService then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
            local coords = GetEntityCoords(ped)
            local distance = #(coords - vector3(locs[selected].Coords[1], locs[selected].Coords[2], locs[selected].Coords[3] ))
			if distance <= 20.0 and IsVehicleModel(vehicle,GetHashKey("taxi")) then
                rkg = 5
				DrawMarker(21,locs[selected].Coords[1], locs[selected].Coords[2], locs[selected].Coords[3] + 0.20,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,0,0,50,1,0,0,1)
				if distance <= 2.5 then
					if IsControlJustPressed(0,38) then
						RemoveBlip(blips)
						if DoesEntityExist(passenger) then
                            SetBlockingOfNonTemporaryEvents(passenger,true)
							FreezeEntityPosition(vehicle, true)
							vSERVER.checkPaymentTaxi()
							Citizen.Wait(3000)
							TaskLeaveVehicle(passenger,vehicle,262144)
							TaskWanderStandard(passenger,10.0,10)
							Citizen.Wait(1100)
							SetVehicleDoorShut(vehicle,3,0)
							Citizen.Wait(1000)
							FreezeEntityPosition(vehicle, false)
						end

						if checkPed then
							local pmodel = math.random(#pedlist)
							modelRequest(pedlist[pmodel].Model)
                            passenger = CreatePed(4,pedlist[pmodel].Hash,locs[selected].CoordsPed[1], locs[selected].CoordsPed[2], locs[selected].CoordsPed[3],3374176,true,false)
                            SetBlockingOfNonTemporaryEvents(passenger,true)
							SetEntityInvincible(passenger, true)
							TaskEnterVehicle(passenger,vehicle,-1,2,1.0,1,0)
							checkPed = false
							lastPassenger = passenger
						else
							passenger = nil
							checkPed = true 
						end

						lSelected = selected
						while true do
							if lSelected == selected then
                                if DoesEntityExist(passenger) then
                                    if IsPedInAnyVehicle(passenger) then
                                        selected = math.random(#locs)
                                    end
                                else
                                    selected = math.random(#locs)
                                end
							else
								break
							end
							Citizen.Wait(1)
						end
						blipCreating(locs, selected)
					end
				end
			end
		end
        Citizen.Wait(rkg)
	end
end)

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

function blipCreating(locs, selected)
    blips = AddBlipForCoord(locs[selected].Coords[1], locs[selected].Coords[2], locs[selected].Coords[3])
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 5)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Corrida de Taxista")
    EndTextCommandSetBlipName(blips)
end