local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

emP = {}
Tunnel.bindInterface(GetCurrentResourceName(),emP)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
vRP = Proxy.getInterface("vRP")
-------------------------------------------------------------------------------------------------
--[ VARIAVEIS ]----------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
local sleep
local emCasa = false
local xCasa,yCasa,zCasa
local blipMapa = false

local sairCasaX = 0
local sairCasaY = 0
local sairCasaZ = 0
local painelCasaX = 0
local painelCasaY = 0
local painelCasaZ = 0
local bauCasaX = 0
local bauCasaY = 0
local bauCasaZ = 0
local idCasa = nil
local apto = nil
local pacote = nil

RegisterNUICallback('buyHome', function(data, cb)
    local result = vSERVER.buyHome(data.id, data.apto, data.type)
	if result == "sucesso" then
		SendNUIMessage({ method = "close" })
		SetNuiFocus(false,false)
	end
    cb(result)
end)

RegisterNUICallback('disallowPerson', function(data, cb)
    vSERVER.disallowPerson(data.name, data.apto, data.idPlayer)
    cb("sucesso")
end)

RegisterNUICallback('authorizePerson', function(data, cb)
    vSERVER.authorizePerson(data.id, data.apto, data.idPlayer)

	local casa = vSERVER.getInfoCasa(idCasa)

	if casa[1] and casa[1].homeApto ~= -1 then
		for k,v in pairs(casa) do
			if v.homeApto == apto then
				casa = v
			end
		end
	end

    cb(casa)
end)

RegisterNUICallback('transferHome', function(data, cb)
    local retorno = vSERVER.transferHome(data.id, data.value, data.idPlayer, data.apto)

	if retorno == "sucesso" then
		SendNUIMessage({ method = "close" })
		SetNuiFocus(false,false)
		vSERVER._leaveHome()
		idCasa = nil
		apto = nil
	end

    cb(retorno)
end)

RegisterNUICallback('payHomeTax', function(data, cb)
    local retorno = vSERVER.payHomeTax(data.id, data.apto)

	if retorno == "sucesso" then
		local casa = vSERVER.getInfoCasa(idCasa)

		if casa[1] and casa[1].homeApto ~= -1 then
			for k,v in pairs(casa) do
				if v.homeApto == apto then
					casa = v
				end
			end
		end

		cb(casa)
	else
		cb(retorno)
	end

end)

RegisterNUICallback('unlockHome', function(data, cb)
    vSERVER.unlockHome(data.name, data.apto)
    cb("sucesso")
end)

RegisterNUICallback('lockHome', function(data, cb)
    vSERVER.lockHome(data.name, data.apto)
    cb("sucesso")
end)



function emP.attCoords(SsairCasaX, SsairCasaY, SsairCasaZ, SpainelCasaX, SpainelCasaY, SpainelCasaZ, SbauCasaX, SbauCasaY, SbauCasaZ, SidCasa, Sapto)
	idCasa = SidCasa
	apto = Sapto
	sairCasaX = SsairCasaX
	sairCasaY = SsairCasaY
	sairCasaZ = SsairCasaZ
	painelCasaX = SpainelCasaX
	painelCasaY = SpainelCasaY
	painelCasaZ = SpainelCasaZ
	bauCasaX = SbauCasaX
	bauCasaY = SbauCasaY
	bauCasaZ = SbauCasaZ
end

RegisterNUICallback('changeInterior', function(data, cb)
    local retorno = vSERVER.changeInterior(data.id, data.apto, data.interior)
	if retorno == "sucesso" then
		SendNUIMessage({ method = "close" })
		SetNuiFocus(false,false)
		sairCasaX, sairCasaY, sairCasaZ, painelCasaX, painelCasaY, painelCasaZ, bauCasaX, bauCasaY, bauCasaZ = vSERVER.enterHome(data.id, data.apto)
	end
    cb(retorno)
end)

RegisterNUICallback('upgradeKeys', function(data, cb)
    local retorno = vSERVER.upgradeKeys(data.id, data.apto)
    cb(retorno)
end)

RegisterNUICallback('upgradeChest', function(data, cb)
    local retorno = vSERVER.upgradeChest(data.id, data.apto)
    cb(retorno)
end)

RegisterNUICallback('getFurnitures', function(data, cb)
    local retorno = vSERVER.getFurnitures(idCasa, apto)
    cb(retorno)
end)

RegisterNUICallback('getMyFurnitures', function(data, cb)
    local retorno = vSERVER.getMyFurnitures(idCasa, apto)
    cb(retorno)
end)

RegisterNUICallback('buyFurniture', function(data, cb)
    local retorno = vSERVER.buyFurniture(data.id, data.type)
    cb(retorno)
end)

RegisterNUICallback('sellFurniture', function(data, cb)
    vSERVER.sellFurniture(data.id)
    cb("sucesso")
end)


local casas = {}

RegisterNetEvent('monkey_homes:attCasas')
AddEventHandler('monkey_homes:attCasas', function(casasServer)
    casas = casasServer
end)

Citizen.CreateThread(function ()
	casas = vSERVER.pegarCasas()
    while true do
		local time = 500
        
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for k, v in pairs(casas) do

            local distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(parseInt(v.x),parseInt(v.y), parseInt(v.z)))
			
            if distance < 10 then
				DrawMarker(23,v.x+0.0,v.y+0.0,v.z-0.95,0,0,0,0,0,0,1.00,1.00,1.00,0, 191, 143,100,0,0,0,0)
				DrawText3Ds(v.x+0.0,v.y+0.0,v.z+0.2, "Imóvel Nº"..v.id, 255, 255, 255)

                time = 1

                if distance < 2.0 then
                    if IsControlJustPressed(1,38) then
						if vSERVER.isValido() then
							pacote = v.interior
							idCasa = v.id

							if v.apartamento == -1 then
								local casa = vSERVER.getInfoCasa(v.id)

								SendNUIMessage({ method = "openHome", body = casa })
								SetNuiFocus(true, true)
							else
								local casa = vSERVER.getInfoCasa(v.id)

								SendNUIMessage({ method = "openApto", body = casa })
								SetNuiFocus(true, true)
							end
						end
					end
				end
			end
		end

		local distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(sairCasaX, sairCasaY, sairCasaZ))

		if distance < 10 then
			DrawMarker(23,sairCasaX, sairCasaY, sairCasaZ-0.95,0,0,0,0,0,0,1.00,1.00,1.00,0, 191, 143,100,0,0,0,0)
			DrawText3Ds(sairCasaX, sairCasaY, sairCasaZ+0.2, "Sair", 255, 255, 255)
			time = 1
			if distance < 2.0 then
				if IsControlJustPressed(1,38) then
					SendNUIMessage({ method = "playSound", body = "outhouse" })
					vSERVER._leaveHome()
					idCasa = nil
					apto = nil
				end
			end
		end

		distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(painelCasaX, painelCasaY, painelCasaZ))

		if distance < 10 then
			DrawMarker(23,painelCasaX, painelCasaY, painelCasaZ-0.95,0,0,0,0,0,0,1.00,1.00,1.00,0, 191, 143,100,0,0,0,0)
			DrawText3Ds(painelCasaX, painelCasaY, painelCasaZ+0.2, "Painel", 255, 255, 255)
			time = 1
			if distance < 2.0 then
				if IsControlJustPressed(1,38) then
					if vSERVER.isValido() then
						local casa = vSERVER.getInfoCasa(idCasa)

						if casa[1] and casa[1].homeApto ~= -1 then
							for k,v in pairs(casa) do
								if v.homeApto == apto then
									casa = v
								end
							end
						end

						SendNUIMessage({ method = "openPainel", body = casa })
						SetNuiFocus(true, true)
					end
				end
			end
		end

		distance = #(vector3(coords[1], coords[2], coords[3]) - vector3(bauCasaX, bauCasaY, bauCasaZ))

		if distance < 10 then
			DrawMarker(23,bauCasaX, bauCasaY, bauCasaZ-0.95,0,0,0,0,0,0,1.00,1.00,1.00,0, 191, 143,100,0,0,0,0)
			DrawText3Ds(bauCasaX, bauCasaY, bauCasaZ+0.2, "Baú", 255, 255, 255)
			time = 1
			if distance < 2.0 then
				if IsControlJustPressed(1,38) then
					if vSERVER.checkIntPermissions(idCasa) then
						local casa = vSERVER.getInfoCasa(idCasa)

						SendNUIMessage({ method = "openChest"})
						SetNuiFocus(true, true)
					end
				end
			end
		end

		Citizen.Wait(time)
	end
end)

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


-- function emP.carregarCasas()
--     casas = vSERVER.carregarCasas()
-- end

-------------------------------------------------------------------------------------------------
--[ HOME ]---------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
RegisterCommand("casas",function(source,args)
	if args[1] then
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		if args[1] == "criar" then
			if vSERVER.isValido() then
				if vSERVER.checkPermission("Admin") then
					vSERVER._createHome(x,y,z)
				end
			end
		elseif args[1] == "sair" then
			vSERVER._leaveHome()
			idCasa = nil
			apto = nil
		elseif args[1] == "list" then
			vSERVER._listHome()
		elseif args[1] == "moveis" then
			if idCasa then
				SendNUIMessage({ method = "openFurnitures" })
				SetNuiFocus(true,true)
			end
		elseif args[1] == "bau" then
			local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId(),true))
			bauCasaX, bauCasaY, bauCasaZ = x2, y2, z2
			vSERVER.setCoordBau(idCasa, apto, x2, y2, z2)
		elseif args[1] == "painel" then
			local x2, y2, z2 = table.unpack(GetEntityCoords(PlayerPedId(),true))
			painelCasaX, painelCasaY, painelCasaZ = x2, y2, z2
			vSERVER.setCoordPainel(idCasa, apto, x2, y2, z2)
		else
			TriggerEvent("Notify","negado","Não foi informado algo válido.")
		end
	else
		vSERVER._casasPlayer()
	end
end)


local houseOpen = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-------------------------------------------------------------------------------------------------
--[ TELEPORTA O PLAYER PARA DENTRO DA CASA DE VOLTA ]--------------------------------------------
-------------------------------------------------------------------------------------------------
-- Citizen.CreateThread(function()
-- 	while true do
-- 		sleep = 1000
-- 		if emCasa then
-- 			local ped = PlayerPedId()
-- 			local x,y,z = table.unpack(GetEntityCoords(ped))
-- 			local bowz,cdz = GetGroundZFor_3dCoord(xCasa,yCasa,zCasa)
-- 			local distance = GetDistanceBetweenCoords(xCasa,yCasa,cdz,x,y,z,true)
-- 			if distance >= 300 then
-- 				sleep = 5
-- 				if xCasa and yCasa and zCasa then
-- 					vRP.teleport(xCasa,yCasa,zCasa)
-- 				end
-- 			end
-- 		end
-- 		Citizen.Wait(sleep)
-- 	end
-- end)
-------------------------------------------------------------------------------------------------
--[ ATIVA DENTRO DA CASA ]-----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
RegisterNetEvent('emCasa:xyz')
AddEventHandler('emCasa:xyz', function(x,y,z)
    if not x then emCasa = false else emCasa = true end
	if emCasa then
		xCasa = x
		yCasa = y
		zCasa = z
	end
end)
-------------------------------------------------------------------------------------------------
--[ BLIPS IMÓVEIS À VENDA ]----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.setBlipsHomes(status)
	if not blipMapa then
		blipMapa = true
		for k,v in pairs(status) do
			local blip = AddBlipForCoord(v.cds.x,v.cds.y,v.cds.z)
			SetBlipSprite(blip,411)
			SetBlipAsShortRange(blip,true)
			if v.tipo ~= -1 then
				SetBlipColour(blip,5)
			else
				SetBlipColour(blip,2)
			end	
			SetBlipScale(blip,0.4)
			BeginTextCommandSetBlipName("STRING")
			EndTextCommandSetBlipName(blip)
			SetTimeout(30000,function()
				if DoesBlipExist(blip) then
					RemoveBlip(blip)
					blipMapa = false
				end
			end)
		end
	end
end
-------------------------------------------------------------------------------------------------
--[ BLIPS IMÓVEIS POSSUIDOS ]----------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
function emP.setBlipsOwner(nome,cds)
	local blip = AddBlipForCoord(cds.x,cds.y,cds.z)
	SetBlipSprite(blip,411)
	SetBlipAsShortRange(blip,true)
	SetBlipColour(blip,36)
	SetBlipScale(blip,0.4)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Residência: ~g~"..nome)
	EndTextCommandSetBlipName(blip)
end

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
    cb("sucesso")
end)

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


-----------------
---   CHEST   ---
-----------------

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2,infos = vSERVER.openChest(idCasa, apto)
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2, infos = infos })
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateSlot",function(data,cb)
	TriggerServerEvent("monkey_home_chest:updateSlot",data.item,data.slot,data.target,data.amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("sumSlot",function(data,cb)
	TriggerServerEvent("monkey_home_chest:sumSlot",data.item,data.slot,data.amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data.item,data.slot,data.amount)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("populateSlot",function(data,cb)
	TriggerServerEvent("monkey_home_chest:populateSlot",data.item,data.slot,data.target,data.amount)
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- chest:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("monkey_home_chest:Update")
AddEventHandler("monkey_home_chest:Update",function(action)
	SendNUIMessage({ method = action })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data.item,data.slot,data.amount)
end)






RegisterNUICallback('placeFurniture', function(data, cb)
    vSERVER.setUsedFurniture(data.id, true)
    cb("sucesso")
end)

RegisterNUICallback('takeFurniture', function(data, cb)

	selecionar_movel_para_remover()
   
    cb("sucesso")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES - MOVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Objects = {}
local initObjects = {}

local lista_objetos_homes = {}
local colocar_objeto_ativo = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(distance,coords)
	local rotation = GetGameplayCamRot()
	local adjustedRotation = vector3((math.pi / 180) * rotation["x"],(math.pi / 180) * rotation["y"],(math.pi / 180) * rotation["z"])
	local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])),math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])),math.sin(adjustedRotation[1]))

	return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------

function emP.objectCoords(model, correcao_z)
	local ped = PlayerPedId()
	local objectProgress = true
	local aplicationObject = false
	local mHash = GetHashKey(model) 

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	local coords = GetEntityCoords(ped)
	local pedHeading = GetEntityHeading(ped)
	local newObject = CreateObject(mHash,coords["x"],coords["y"],coords["z"],false,false,false)
	SetEntityCollision(newObject,false,false)
	SetEntityHeading(newObject,pedHeading)
	SetEntityAlpha(newObject,100,false)

	while objectProgress do
		local ped = PlayerPedId()
		local cam = GetGameplayCamCoord()
		local handle = StartExpensiveSynchronousShapeTestLosProbe(cam,GetCoordsFromCam(10.0,cam),-1,ped,4)
		local _,_,coords = GetShapeTestResult(handle)

		--SetEntityCoordsNoOffset(newObject,coords["x"],coords["y"],coords["z"],1,0,0)
		SetEntityCoordsNoOffset(newObject,coords["x"],coords["y"],coords["z"] + correcao_z,1,0,0)
        colocar_objeto_ativo = true

		dwText("~g~F~w~  CANCELAR",4,0.015,0.86,0.38,255,255,255,255)
		dwText("~g~E~w~  COLOCAR OBJETO",4,0.015,0.89,0.38,255,255,255,255)
		dwText("~y~SCROLL UP~w~  GIRA ESQUERDA",4,0.015,0.92,0.38,255,255,255,255)
		dwText("~y~SCROLL DOWN~w~  GIRA DIREITA",4,0.015,0.95,0.38,255,255,255,255)

		dwText("~g~Z~w~ PageUp + | PageDown - | "..correcao_z,4,0.015,0.81,0.38,255,255,255,255)

		if IsControlPressed(1,10) then
			correcao_z = correcao_z + 0.01 
		end

		if IsControlPressed(1,11) then
			correcao_z = correcao_z - 0.01  
		end

		if IsControlJustPressed(1,38) then
			aplicationObject = true
			objectProgress = false
            
		end
		
		if IsControlJustPressed(1,38) then
			aplicationObject = true
			objectProgress = false
            
		end

		if IsControlJustPressed(1,49) then
			objectProgress = false
		end

		if IsControlJustPressed(1,180) then
			local headObject = GetEntityHeading(newObject)
			SetEntityHeading(newObject,headObject + 2.5)
		end

		if IsControlJustPressed(1,181) then
			local headObject = GetEntityHeading(newObject)
			SetEntityHeading(newObject,headObject - 2.5)
		end

		PlaceObjectOnGroundProperly(newObject)

		Citizen.Wait(1)
	end

    if aplicationObject then

        colocar_objeto_ativo = false

        local headObject = GetEntityHeading(newObject)
        local coordsObject = GetEntityCoords(newObject)
        local _,GroundZ = GetGroundZFor_3dCoord(coordsObject["x"],coordsObject["y"],coordsObject["z"])

		local coords_ped = GetEntityCoords(ped)

		local Z_c = coordsObject["z"]

		if coordsObject["z"] < coords_ped.z then 
			Z_c = coords_ped.z
		end

        local newCoords = {
            ["x"] = coordsObject["x"],
            ["y"] = coordsObject["y"],
            --["z"] = GroundZ
			["z"] = Z_c
        }

	
        DeleteEntity(newObject)

        local SpawnObject = CreateObject(mHash, newCoords.x,newCoords.y,newCoords.z, true)
        SetEntityHeading(SpawnObject,headObject)
        PlaceObjectOnGroundProperly(SpawnObject)

        FreezeEntityPosition(SpawnObject,true)
                    
        return aplicationObject, mHash, newCoords, headObject, SpawnObject
    else 
        DeleteEntity(newObject)
        colocar_objeto_ativo = false
        return false
    end
end

function emP.remDropMoveis()
 
	while true do

		drawTxt("Monkey Hash ativado \nBotão esquerdo do mouse para selecionar e o direito para finalizar",1,0.5,0.93,0.5,255,255,255,180)
			
		local ped = GetPlayerPed(-1)
		local start,fin = GetCoordsInFrontOfCam(0,5000)
		local ray = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,16,ped,5000)
		local _ray,hit,pos,norm,ent = GetShapeTestResult(ray)
	
		local rayB = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,1,ped,5000)
		local _rayB,hitB,posB,normB,entB = GetShapeTestResult(rayB)
  
	  	if hit and ent > 0 then   
			DrawSphere(pos, 0.05, 0,255,0, 0.5)

			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,142,true)
			if IsDisabledControlJustReleased(0,24) then
				DeleteEntity(ent)
				TriggerServerEvent("tryDeleteEntity",ObjToNet(ent))
			elseif IsDisabledControlJustReleased(0,25) then
				break
			end
		  	DrawEntityBoundingBox(ent,0,100,0,80)
	  	else

			if hitB and GetEntityType(entB) > 0 then   
				DrawSphere(posB, 0.05, 0,255,0, 0.5)
	
				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,142,true)
				if IsDisabledControlJustReleased(0,24) then
					DeleteEntity(entB)
					TriggerServerEvent("tryDeleteEntity",ObjToNet(entB))
				elseif IsDisabledControlJustReleased(0,25) then
					break
				end
				  DrawEntityBoundingBox(entB,0,100,0,80)
			else
			
				DrawSphere(posB, 0.05, 255,0,0, 0.5)
				
				if IsDisabledControlJustReleased(0,25) then
					break
				end
			end

	  	end
	  	Wait(0)
	end
   
	return doors
end


RegisterCommand("addMoveisLoja",function(source,args,rawCommand)
    inserir_moveis_para_loja()
end)

local camera = false
local nomeMovel = nil

function inserir_moveis_para_loja()
 
	while true do

		if camera == false then 
			drawTxt("Monkey Hash ativado \nBotão esquerdo do mouse para selecionar e o direito para finalizar",1,0.5,0.93,0.5,255,255,255,180)
		end
		
		local ped = GetPlayerPed(-1)
		local start,fin = GetCoordsInFrontOfCam(0,5000)
		local ray = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,16,ped,5000)
		local _ray,hit,pos,norm,ent = GetShapeTestResult(ray)
	
		local rayB = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,1,ped,5000)
		local _rayB,hitB,posB,normB,entB = GetShapeTestResult(rayB)
  
	  
	  	if hit and ent > 0 then   

			if camera == false then 
				DrawSphere(pos, 0.05, 0,255,0, 0.5)
			end
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,142,true)
  
			if IsDisabledControlJustReleased(0,24) then
		
				camera = true
				nomeMovel = GetEntityArchetypeName(ent)

				CreateMobilePhone(1)
				CellCamActivate(true, true)

			elseif IsDisabledControlJustReleased(0,25) then
				break
			end
		  	DrawEntityBoundingBox(ent,0,100,0,80)
			
	  	else

			if hitB and GetEntityType(entB) > 0 then   
				if camera == false then 
					DrawSphere(posB, 0.05, 0,255,0, 0.5)
				end

				DisableControlAction(0,24,true)
				DisableControlAction(0,25,true)
				DisableControlAction(0,142,true)
				if IsDisabledControlJustReleased(0,24) then
					camera = true
					nomeMovel = GetEntityArchetypeName(entB)

					CreateMobilePhone(1)
					CellCamActivate(true, true)

				elseif IsDisabledControlJustReleased(0,25) then
					break
				end
				  DrawEntityBoundingBox(entB,0,100,0,80)
			else
			
				if camera == false then 
					DrawSphere(posB, 0.05, 255,0,0, 0.5)
				end

				if IsDisabledControlJustReleased(0,25) then
					  break
				end
			end


			
	  	end
	  	Wait(0)
	end
   
	return doors
end



-----------------------------------------------------------------------------------------------------------------------------------------
---- CAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustPressed(0, 176) and camera == true then -- TAKE.. PIC

			local url_foto = nil
			CellCamActivate(true, true)
			local webWookFoto = 'https://discord.com/api/webhooks/1027601205330989086/zbBAAJjF-9Ku5cm5eMawR-NAtpg54NI5M1DM6wLxN3A09q-VbqImCy7Mlij3ovraUG-J'
		
			exports['screenshot-basic']:requestScreenshotUpload(webWookFoto, 'files[]', function(data)
				local resp = json.decode(data)
				local url = resp["attachments"][1]['url']
				url_foto = url
				CellCamActivate(false, false)
				DestroyMobilePhone()
				camera = false
				Citizen.Wait(1000)   
				vSERVER.InserirMovelHash(nomeMovel, url_foto)
			end) 

		end
				
		if IsControlJustPressed(1, 177) and camera == true then -- CLOSE PHONE
			DestroyMobilePhone()
			camera = false
			CellCamActivate(false, false)
			Citizen.Wait(2500)
		end
			
		if camera == true then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()
		end

	end
end)


Citizen.CreateThread(function()
    local destrava  = false
	while true do 
        local var_temp = 150
        if colocar_objeto_ativo then 
            destrava = true
            var_temp = 1
            HideHudComponentThisFrame(19)
        else
            if destrava then 
                destrava = false
                local num = 1
                while num < 100 do
                    HideHudComponentThisFrame(19)
                    Wait(1)
                    num = num + 1
                end
            end
        end
        Wait(var_temp)
    end
end)


RegisterNUICallback('enterHome', function(data, cb)
	apto = data.apto
	sairCasaX, sairCasaY, sairCasaZ, painelCasaX, painelCasaY, painelCasaZ, bauCasaX, bauCasaY, bauCasaZ, objetos_s, render_mundo = vSERVER.enterHome(data.id, data.apto)
	SendNUIMessage({ method = "close" })
	SetNuiFocus(false,false)

	Wait(150)
	
	if render_mundo then 
		cololocar_moveis(objetos_s)
	end

    cb("sucesso")
end)


function cololocar_moveis(objetos_s)
	Wait(500)
	for _,value in pairs(objetos_s) do 

		local mHash = GetHashKey(value.nome)

		RequestModel(mHash)
		while not HasModelLoaded(mHash) do
			Citizen.Wait(1)
		end

		local SpawnObject = CreateObject(mHash, value.x,value.y,value.z, true)
        SetEntityHeading(SpawnObject,value.h)
        PlaceObjectOnGroundProperly(SpawnObject)
        FreezeEntityPosition(SpawnObject,true)
		Wait(200)
	end
end

function emP.deletar_movel(nome, x, y, z)
	local hash_code = GetHashKey(nome)

	local SpawnObject = GetClosestObjectOfType(x, y, z, 2.0, hash_code,0,0,0)
	--RemoveModelHide( x, y, z, 2.0, hash_code, false )
	TriggerServerEvent("tryDeleteEntity",ObjToNet(SpawnObject))
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- DWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function dwText(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end


-- Depedencias para remover moveis

function selecionar_movel_para_remover()

	while true do
		drawTxt("Ativado \nBotão esquerdo do mouse para selecionar movel para remove-lo e o direito para finalizar",1,0.5,0.93,0.5,255,255,255,180)
		local ped = GetPlayerPed(-1)
		local start,fin = GetCoordsInFrontOfCam(0,5000)
		local ray = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,16,ped,5000)
		local _ray,hit,pos,norm,ent = GetShapeTestResult(ray)
	
		local rayB = StartShapeTestRay(start.x,start.y,start.z,fin.x,fin.y,fin.z,1,ped,5000)
		local _rayB,hitB,posB,normB,entB = GetShapeTestResult(rayB)
	
		
		if hit and ent > 0 then   
			DrawSphere(pos, 0.05, 0,255,0, 0.5)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,142,true)
	
			if IsDisabledControlJustReleased(0,24) then
	
				local door_loc    = GetEntityCoords(ent) --pos --
				local door_rot    = GetEntityRotation(ent,5)

				local door_model  = GetEntityModel(ent)

				local rows = vSERVER.getObjetoBancoRemover(GetEntityArchetypeName(ent),door_loc.x,door_loc.y,door_loc.z)

				if rows[1] then 
					vSERVER.setUsedFurniture(rows[1].id_movel_user, false)
					TriggerServerEvent("tryDeleteEntity",ObjToNet(ent))
				end
					
				--TriggerServerEvent("tryDeleteEntity",ObjToNet(ent))

			elseif IsDisabledControlJustReleased(0,25) then
				break
			elseif IsDisabledControlJustReleased(0,38) then
				break
			end
			DrawEntityBoundingBox(ent,0,100,0,80)
			
		else

			if hitB and GetEntityType(entB) > 0 then  

				local door_loc    = GetEntityCoords(entB) --pos --
				local door_rot    = GetEntityRotation(entB,5)

				local door_model  = GetEntityModel(entB)

				local rows = vSERVER.getObjetoBancoRemover(GetEntityArchetypeName(entB),door_loc.x,door_loc.y,door_loc.z)

				if rows[1] then 
					vSERVER.setUsedFurniture(rows[1].id_movel_user, false)
					TriggerServerEvent("tryDeleteEntity",ObjToNet(entB))
				end

			else 
				DrawSphere(posB, 0.05, 255,0,0, 0.5)
			
				if IsDisabledControlJustReleased(0,25) then
					break
				end

			end
			
		end
		Wait(0)
	end
   
	return doors
  end
  

-- depedencias

function GetCoordsInFrontOfCam(...)   
	local unpack = table.unpack   
	local coords,direction = GetGameplayCamCoord(), RotationToDirection()   
	local inTable  = {...}   
	local retTable = {}    
  
	if (#inTable == 0) or (inTable[1] < 0.000001) then 
	  inTable[1] = 0.000001
	end    
  
	for k,distance in pairs(inTable) do     
	  if (type(distance) == "number") then       
		if (distance == 0) then         
		  retTable[k] = coords       
		else         
		  retTable[k] = vector3(coords.x + (distance*direction.x),coords.y + (distance*direction.y),coords.z + (distance*direction.z))       
		end     
	  end   
	end   
  
	return unpack(retTable) 
  end
  
  
  function RotationToDirection(rot)   
	if (rot == nil) then 
	  rot = GetGameplayCamRot(2);  
	end   
  
	local  rotZ = rot.z  * ( 3.141593 / 180.0 )   
	local  rotX = rot.x  * ( 3.141593 / 180.0 )   
	local  c = math.cos(rotX);   
	local  multXY = math.abs(c)   
	local  res = vector3( ( math.sin(rotZ) * -1 )*multXY, math.cos(rotZ)*multXY, math.sin(rotX) ) 
  
	return res 
  end  
  
  function DrawEntityBoundingBox(entity,r,g,b,a)
	local box = GetEntityBoundingBox(entity)
	DrawBoundingBox(box,r,g,b,a)
  end
  
  function GetEntityBoundingBox(entity)
	local min,max = GetModelDimensions(GetEntityModel(entity))
	local pad = 0.001
  
	return {
	  [1] = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, min.z - pad),
	  [2] = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, min.z - pad),
	  [3] = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, min.z - pad),
	  [4] = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, min.z - pad),
  
	  [5] = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, min.y - pad, max.z + pad),
	  [6] = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, min.y - pad, max.z + pad),
	  [7] = GetOffsetFromEntityInWorldCoords(entity, max.x + pad, max.y + pad, max.z + pad),
	  [8] = GetOffsetFromEntityInWorldCoords(entity, min.x - pad, max.y + pad, max.z + pad),
	}
  end
  
  function DrawBoundingBox(box,r,g,b,a)
	local polyMatrix = GetBoundingBoxPolyMatrix(box)
	local edgeMatrix = GetBoundingBoxEdgeMatrix(box)
  
	DrawPolyMatrix(polyMatrix,r,g,b,a)
	DrawEdgeMatrix(edgeMatrix,255,255,255,255)
  end
  
  function GetBoundingBoxPolyMatrix(box)
	 return {
	  [1]  = {[1] = box[3],  [2] = box[2],  [3] = box[1]},
	  [2]  = {[1] = box[4],  [2] = box[3],  [3] = box[1]},
  
	  [3]  = {[1] = box[5],  [2] = box[6],  [3] = box[7]},
	  [4]  = {[1] = box[5],  [2] = box[7],  [3] = box[8]},
  
	  [5]  = {[1] = box[3],  [2] = box[4],  [3] = box[7]},
	  [6]  = {[1] = box[8],  [2] = box[7],  [3] = box[4]},
  
	  [7]  = {[1] = box[1],  [2] = box[2],  [3] = box[5]},
	  [8]  = {[1] = box[6],  [2] = box[5],  [3] = box[2]},
  
	  [9]  = {[1] = box[2],  [2] = box[3],  [3] = box[6]},
	  [10] = {[1] = box[3],  [2] = box[7],  [3] = box[6]},
  
	  [11] = {[1] = box[5],  [2] = box[8],  [3] = box[4]},
	  [12] = {[1] = box[5],  [2] = box[4],  [3] = box[1]},
	 }
  end
  
  function GetBoundingBoxEdgeMatrix(box)
	 return {
	  [1]  = {[1] = box[1], [2] = box[2]},
	  [2]  = {[1] = box[2], [2] = box[3]},
	  [3]  = {[1] = box[3], [2] = box[4]},
	  [4]  = {[1] = box[4], [2] = box[1]},
  
	  [5]  = {[1] = box[5], [2] = box[6]},
	  [6]  = {[1] = box[6], [2] = box[7]},
	  [7]  = {[1] = box[7], [2] = box[8]},
	  [8]  = {[1] = box[8], [2] = box[5]},
  
	  [9]  = {[1] = box[1], [2] = box[5]},
	  [10] = {[1] = box[2], [2] = box[6]},
	  [11] = {[1] = box[3], [2] = box[7]},
	  [12] = {[1] = box[4], [2] = box[8]},
	 }
  end
  
  function DrawPolyMatrix(polyCollection,r,g,b,a)
	for k=1,#polyCollection,1 do
	  local v = polyCollection[k]
	  DrawPoly(v[1].x,v[1].y,v[1].z, v[2].x,v[2].y,v[2].z, v[3].x,v[3].y,v[3].z, r,g,b,a)
	end
  end
  
  function DrawEdgeMatrix(linesCollection,r,g,b,a)
	for k=1,#linesCollection,1 do
	  local v = linesCollection[k]
	  DrawLine(v[1].x,v[1].y,v[1].z, v[2].x,v[2].y,v[2].z, r,g,b,a)
	end
  end
  
  function drawTxt(text,font,x,y,scale,r,g,b,a)
	  SetTextFont(font)
	  SetTextScale(scale,scale)
	  SetTextColour(r,g,b,a)
	  SetTextOutline()
	  SetTextCentre(1)
	  SetTextEntry("STRING")
	  AddTextComponentString(text)
	  DrawText(x,y)
  end
  
  function DrawText3D(x,y,z,text)
	  local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)
  
	  if onScreen then
		  BeginTextCommandDisplayText("STRING")
		  AddTextComponentSubstringKeyboardDisplay(text)
		  SetTextColour(255,255,255,150)
		  SetTextScale(0.35,0.35)
		  SetTextFont(4)
		  SetTextCentre(1)
		  EndTextCommandDisplayText(_x,_y)
  
		  local width = string.len(text) / 160 * 0.45
		  DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	  end
  end