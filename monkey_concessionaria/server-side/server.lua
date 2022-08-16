local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local autorizado = true

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_concessionaria", cnVRP)
vCLIENT = Tunnel.getInterface("monkey_concessionaria")

-- validação

Citizen.CreateThread(function ()
    for i = 1, 3, 1 do
        if autorizado == true then
            break
        end
        VerificarModulo()
        Citizen.Wait(5000)
    end
    print('autorizado ', autorizado)
end)

function VerificarModulo()
    local url = "http://bravorp.online:8082/ModuleValidator/validator/module?module=craft&login="..Config.login.."&password="..Config.senha
    PerformHttpRequest(url, function(status, text, headers) if status == 200 then autorizado = true end end, 'GET', nil, nil)
end

-- Prepares

-- vRP.prepare("create_monkey_craft", "CREATE TABLE IF NOT EXISTS monkey_craft (id BIGINT auto_increment NOT NULL, x varchar(20) NOT NULL, y varchar(20) NOT NULL, z varchar(20) NOT NULL, permissao varchar(100) NOT NULL, nome_craft varchar(100) NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")


function cnVRP.TodosVeiculos()
    local veiculos = {}
    
    for k,v in pairs(vRP.vehicleGlobal()) do

        if v[4] and v[4] == "cars" then
            local car = {
                ["nome"] = k,
                ["nome_vitrine"] = v[1],
                ["preco"] = v[3],
                ["kg"] = v[2]
            }
            table.insert(veiculos,car)
        end
    end

    return veiculos
end


vRP.prepare("vRP/get_vehicles_no_vip","SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vip = false")
vRP.prepare("vRP/insert_trucker", "INSERT INTO trucker_trucks (user_id, truck_name, driver) VALUES(@user_id, @vehicle, 0)")

function cnVRP.insertVehicleOnGarage(vehicle, preco)

    local source = source
	local user_id = vRP.getUserId(source)

	local name = vehicle
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local vehName = tostring(name)
		local vehPlate = vRP.vehList(source,11)
		local todos_veiculos_nao_vip = vRP.query("vRP/get_vehicles_no_vip",{ user_id = parseInt(user_id) })
		local myGarages = vRP.getInformation(user_id)
		local plateId = vRP.getVehiclePlate(vehPlate)
	
		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			TriggerClientEvent("Notify",source,"vermelho","Encontramos faturas pendentes.",3000)
			return false
		else

			if vRP.vehicleType(name) ~= "work" then
				if parseInt(#todos_veiculos_nao_vip) >= parseInt(myGarages[1].garage) then
					TriggerClientEvent("Notify",source,"amarelo","Você atingiu o máximo de veículos em sua garagem.",3000)
					return false
				else
					local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehName })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"amarelo","Você já possui um <b>"..vehName.."</b>.",3000)
						return false
					else
						
						if vRP.paymentBank(user_id,parseInt(preco)) then
							addToTruckerTrucks(user_id, vehName)
							local placa_nova = vRP.generatePlateNumber()
							vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehName, plate = placa_nova, phone = vRP.getPhone(user_id), work = tostring(false) })
							-- vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = name, arrest = 1, time = parseInt(os.time()) })
							TriggerClientEvent("Notify",source,"verde","A compra foi concluída com sucesso.",5000)
							return true
						else
							TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente na sua conta bancária.",5000)
							return false
						end
						
					end
				
				end


			else
				TriggerClientEvent("Notify",source,"amarelo","Esse veiculos é de trabalho, avise a prefeitura. NOME: "..name,20000)
				return false
			end
		end
		
	end
end



function addToTruckerTrucks(user_id, name)
	if name == "actros" or name == "man" or name == "daf" or name == "t680" or name == "w900" or name == "vnl780" then
		vRP.execute("vRP/insert_trucker",{ user_id = parseInt(user_id), vehicle = name })
	end
end