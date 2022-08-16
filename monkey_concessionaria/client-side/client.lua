local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_concessionaria", cnVRP)
vSERVER = Tunnel.getInterface("monkey_concessionaria")


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local concessionaria_aberta = false

local cam = -1
local distance = 0
local qtd_zoom = 0
local qtd_giros = 0

local veiculo = nil
local veiculo_testeDrive = nil
local coords_ped = nil
local coords_ped_conc = nil



Citizen.CreateThread(function()
    while true do

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        local time = 1000

        for k, value in pairs(Config.concessionarias) do

            local distance = #(coords - vector3(value.x, value.y, value.z))

            if distance < 10 then
                DrawMarker(36, value.x, value.y, value.z, 0, 0, 0, 0, 0, 0, 0.80, 0.80, 0.80, 255, 0, 0, 100, 0, 0, 0, 1)
                DrawMarker(27, value.x, value.y, value.z - 0.99, 0, 0, 0, 0, 0, 0, 1.00, 1.00, 1.00, 255, 0, 0, 100, 0, 0
                    , 0, 1)
                if distance < 1.2 then
                    if IsControlJustPressed(0, 38) then

                        coords_ped_conc = GetEntityCoords(ped)
                        coords_ped = coords_ped_conc

                        concessionaria_aberta = true

                        DoScreenFadeOut(500)
                        Wait(500)
                        SetEntityCoords(ped, Config.vitrine_car.x, Config.vitrine_car.y, Config.vitrine_car.z, 1, 0, 0, 1)
                        cnVRP.noClip()
                        Wait(500)
                        DoScreenFadeIn(500)


                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            acao = true,
                            carros = vSERVER.TodosVeiculos()
                        })


                        enableCam()
                        SpawnVehicleLocal("chino", Config.vitrine_car.x, Config.vitrine_car.y, Config.vitrine_car.z)

                    end
                end

                time = 1
            end

        end



        Wait(time)
    end
end)


RegisterNUICallback("sair", function(data)
    concessionaria_aberta = false
    DoScreenFadeOut(500)
    Wait(500)

    local ped = PlayerPedId()
    SetEntityCoords(ped, coords_ped_conc.x, coords_ped_conc.y, coords_ped_conc.z, 1, 0, 0, 1)
    disableCam()
    SetNuiFocus(false, false)
    cnVRP.noClip()
    Wait(500)
    DoScreenFadeIn(500)
end)





-- ====================================================================================================
-- Funcoes de Retorno - START
-- ====================================================================================================
RegisterNUICallback("mostrarCarro", function(data)

    local nome_carro = data.nome
    SpawnVehicleLocal(nome_carro, Config.vitrine_car.x, Config.vitrine_car.y, Config.vitrine_car.z,
        Config.vitrine_car.grau)

end)

RegisterNUICallback("abrirPortas", function(data)
    SetVehicleDoorOpen(veiculo, 0, 0, 0)
    SetVehicleDoorOpen(veiculo, 1, 0, 0)
    SetVehicleDoorOpen(veiculo, 2, 0, 0)
    SetVehicleDoorOpen(veiculo, 3, 0, 0)
    SetVehicleDoorOpen(veiculo, 4, 0, 0)
end)


RegisterNUICallback('fecharPortas', function(data)
    SetVehicleDoorShut(veiculo, 0, 0)
    SetVehicleDoorShut(veiculo, 1, 0)
    SetVehicleDoorShut(veiculo, 2, 0)
    SetVehicleDoorShut(veiculo, 3, 0)
    SetVehicleDoorShut(veiculo, 4, 0)

end)


RegisterNUICallback("testeDrive", function(data)

    concessionaria_aberta = false
    disableCam()
    SetNuiFocus(false, false)
    cnVRP.noClip()
    local ped = PlayerPedId()
    -- coords_ped = GetEntityCoords(ped)
    test_drive(data.nome)

end)


RegisterNUICallback("mudarCor", function(data)

    local r, g, b = parseInt(data.r), parseInt(data.g), parseInt(data.b)
    -- cor primária
    SetVehicleCustomPrimaryColour(veiculo, r, g, b)
    -- cor secundária
    SetVehicleCustomSecondaryColour(veiculo, r, g, b)

end)


RegisterNUICallback("tecladoOff", function(data)

    SetNuiFocus(true, true)

    

end)
RegisterNUICallback("tecladoOn", function(data)

    SetNuiFocus(false, true)

    
end)

-- ====================================================================================================
-- Funcoes de Retorno- END
-- ====================================================================================================



function cnVRP.noClip()

    local ped = PlayerPedId()

    if concessionaria_aberta then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end
end

RegisterCommand('testeConcessionaria', function(source, args, rawCommand)
    concessionaria_aberta = true

    --local ped = PlayerPedId()

    --SetEntityCoords(ped, Config.camera.x, Config.camera.y, Config.camera.z-0.99, 1, 0, 0, 0)
    --SetEntityHeading(ped,Config.camera.grau)
    enableCam()

    cnVRP.noClip()

    SpawnVehicleLocal(args[1], Config.vitrine_car.x, Config.vitrine_car.y, Config.vitrine_car.z)
end)

RegisterCommand('testeDrive', function(source, args, rawCommand)
    local ped = PlayerPedId()
    coords_ped = GetEntityCoords(ped)
    test_drive(args[1])
end)



RegisterCommand('testeConcessionariaSair', function(source, args, rawCommand)
    concessionaria_aberta = false
    disableCam()
    cnVRP.noClip()
end)

RegisterCommand('testeConcessionariaCor', function(source, args, rawCommand)
    local r, g, b = parseInt(args[1]), parseInt(args[2]), parseInt(args[3])
    -- cor primária
    SetVehicleCustomPrimaryColour(veiculo, r, g, b)
    -- cor secundária
    SetVehicleCustomSecondaryColour(veiculo, r, g, b)

end)

RegisterCommand('testeConcessionariaPortasAbrir', function(source, args, rawCommand)

    SetVehicleDoorOpen(veiculo, 0, 0, 0)
    SetVehicleDoorOpen(veiculo, 1, 0, 0)
    SetVehicleDoorOpen(veiculo, 2, 0, 0)
    SetVehicleDoorOpen(veiculo, 3, 0, 0)
    SetVehicleDoorOpen(veiculo, 4, 0, 0)

end)

RegisterCommand('testeConcessionariaPortasFechar', function(source, args, rawCommand)

    SetVehicleDoorShut(veiculo, 0, 0)
    SetVehicleDoorShut(veiculo, 1, 0)
    SetVehicleDoorShut(veiculo, 2, 0)
    SetVehicleDoorShut(veiculo, 3, 0)
    SetVehicleDoorShut(veiculo, 4, 0)

end)




-----------------------------------------------------------------------------------------------------------------------------------------
-- ENABLECAM
-----------------------------------------------------------------------------------------------------------------------------------------
function enableCam()

    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)

    if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        --SetCamCoord(cam,Config.camera.x, Config.camera.y, Config.camera.z+2.0)
        distance = Config.vitrine_car.y + 5.0
        SetCamCoord(cam, Config.vitrine_car.x, distance, Config.vitrine_car.z + 2.0)

        SetCamRot(cam, -25.0, 0.0, Config.camera.grau)
    end

end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SETUPCAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("setupCam", function(data)
    local value = data.value

    if value == 1 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.65)
    elseif value == 2 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
    elseif value == 3 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + -0.5)
    else
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.5)
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECAM
-----------------------------------------------------------------------------------------------------------------------------------------
function disableCam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 100
        local ped = PlayerPedId()
        if concessionaria_aberta then
            timeDistance = 1

            if IsControlJustPressed(0, 23) then
                SendNUIMessage({
                    foco = false
                })
                SetNuiFocus(true, true)
            end

            if IsControlJustPressed(0, 31) then
                if qtd_zoom < 15 then
                    qtd_zoom = qtd_zoom + 1
                    distance = distance + 0.1
                    SetCamCoord(cam, Config.vitrine_car.x, distance, (Config.vitrine_car.z + 2.0) + (0.1 * qtd_zoom))
                    local root_cam_x = -25.0 - qtd_zoom
                    if root_cam_x < -25.0 then
                        root_cam_x = -25.0
                    end
                    SetCamRot(cam, root_cam_x, 0.0, Config.camera.grau)

                end
            end
            if IsControlJustPressed(0, 32) then
                if qtd_zoom > -10 then
                    qtd_zoom = qtd_zoom - 1
                    distance = distance - 0.1
                    SetCamCoord(cam, Config.vitrine_car.x, distance, (Config.vitrine_car.z + 2.0) + (0.1 * qtd_zoom))
                    local root_cam_x = -25.0 - qtd_zoom
                    if root_cam_x < -25.0 then
                        root_cam_x = -25.0
                    end
                    SetCamRot(cam, root_cam_x, 0.0, Config.camera.grau)
                end
            end
            if IsControlPressed(0, 34) then
                qtd_giros = qtd_giros + 1.0

                SetEntityHeading(veiculo, Config.vitrine_car.grau + qtd_giros)

            end
            if IsControlPressed(0, 35) then
                qtd_giros = qtd_giros - 1.0

                SetEntityHeading(veiculo, Config.vitrine_car.grau + qtd_giros)
            end
        end

        Citizen.Wait(timeDistance)
    end
end)





function SpawnVehicleLocal(model, c_x, c_y, c_z, c_g)

    if loading or GetNumberOfStreamingRequests() > 0 then return end

    local ped = PlayerPedId()
    if veiculo ~= nil then
        ReqAndDelete(veiculo)
    end
    for i = 1, 2 do
        local nearveh = GetClosestVehicle(c_x, c_y, c_z, 2.000, 0, 70)
        if DoesEntityExist(nearveh) then
            ReqAndDelete(nearveh)
        end
        local tentativas = 100
        while DoesEntityExist((nearveh)) and tentativas > 0 do
            ReqAndDelete(nearveh)
            Wait(100)
            tentativas = tentativas - 1
        end
    end

    local hash = GetHashKey(model)
    local count = 0
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local tentativas = 500
        while not HasModelLoaded(hash) and tentativas > 0 do
            Citizen.Wait(0)
            tentativas = tentativas - 1
        end
        loading = true
    end
    loading = false

    veiculo = CreateVehicle(hash, c_x, c_y, c_z, c_g, 0, 1)
    local tentativas = 500
    -- verificar se é a direção
    SetEntityHeading(veiculo, c_g)
    FreezeEntityPosition(veiculo, true)
    SetEntityCollision(veiculo, false)
    SetVehicleDirtLevel(veiculo, 0.0)

    currentcar = veiculo
    if currentcar ~= veiculo then
        ReqAndDelete(veiculo)
        SetModelAsNoLongerNeeded(hash)
    end
    SetModelAsNoLongerNeeded(hash)
    SetVehicleEngineOn(veiculo, true, true, false)
    Wait(500)
end

function ReqAndDelete(object, detach)
    if DoesEntityExist(object) then
        NetworkRequestControlOfEntity(object)
        local attempt = 0
        while not NetworkHasControlOfEntity(object) and attempt < 100 and DoesEntityExist(object) do
            NetworkRequestControlOfEntity(object)
            Citizen.Wait(11)
            attempt = attempt + 1
        end
        DetachEntity(object, 0, false)

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

function spawnVeiculo_testeDrive(name)

    local mHash = GetHashKey(name)

    RequestModel(mHash)

    while not HasModelLoaded(mHash) do
        RequestModel(mHash)
        Citizen.Wait(10)
    end

    if HasModelLoaded(mHash) then
        local ped = PlayerPedId()

        veiculo_testeDrive = CreateVehicle(mHash, Config.teste_drive.x + 0.01, Config.teste_drive.y + 0.01,
            Config.teste_drive.z + 1.0, Config.teste_drive.grau, true, false)
        SetEntityHeading(veiculo_testeDrive, Config.teste_drive.grau)
        SetVehicleDirtLevel(veiculo_testeDrive, 0.0)
        SetVehRadioStation(veiculo_testeDrive, "OFF")
        SetVehicleNumberPlateText(veiculo_testeDrive, "11AAA000")
        SetEntityAsMissionEntity(veiculo_testeDrive, true, true)

        --SetPedIntoVehicle(ped,nveh,-1)

        SetModelAsNoLongerNeeded(mHash)
    end


end

RegisterCommand('sw', function(source, args, rawCommand)

    DoScreenFadeIn(500)

end)



function test_drive(model)

    local ped = PlayerPedId()

    DoScreenFadeOut(500)

    spawnVeiculo_testeDrive(model)


    SetPedIntoVehicle(ped, veiculo_testeDrive, -1)


    Wait(500)
    --SetEntityCoords(veiculo_testeDrive,Config.teste_drive.x+0.01, Config.teste_drive.y+0.01, Config.teste_drive.z+0.02,1,0,0,1)
    --SetEntityHeading(veiculo_testeDrive,Config.teste_drive.grau)
    Wait(500)
    DoScreenFadeIn(500)

    FreezeEntityPosition(veiculo_testeDrive, false)

    local rtime = 60

    while rtime > 0 do
        if GetPedInVehicleSeat(veiculo_testeDrive, -1) ~= ped then
            DoScreenFadeOut(500)
            Wait(500)
            SetEntityCoords(ped, coords_ped.x, coords_ped.y, coords_ped.z, 1, 0, 0, 1)
            if IsEntityAVehicle(veiculo_testeDrive) then
                DeleteEntity(veiculo_testeDrive)
            end
            Wait(500)
            DoScreenFadeIn(500)
            return
        end
        rtime = rtime - 1
        Wait(1000)
    end
    if IsEntityAVehicle(veiculo_testeDrive) then
        DoScreenFadeOut(500)
        Wait(500)
        SetEntityCoords(ped, coords_ped.x, coords_ped.y, coords_ped.z, 1, 0, 0, 1)
        if IsEntityAVehicle(veiculo_testeDrive) then
            DeleteEntity(veiculo_testeDrive)
        end
        Wait(500)
        DoScreenFadeIn(500)
    end
end
