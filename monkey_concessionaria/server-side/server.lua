local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local autorizado = true

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

cnVRP = {}
Tunnel.bindInterface("monkey_concessionaria", cnVRP)
vCLIENT = Tunnel.getInterface("monkey_concessionaria")


local lista_carros = {}




Citizen.CreateThread(function()
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
	local url = "http://bravorp.online:8082/ModuleValidator/validator/module?module=craft&login=" ..
		Config.login .. "&password=" .. Config.senha
	PerformHttpRequest(url, function(status, text, headers) if status == 200 then autorizado = true end end, 'GET', nil, nil)
end

-- Prepares

-- vRP.prepare("create_monkey_craft", "CREATE TABLE IF NOT EXISTS monkey_craft (id BIGINT auto_increment NOT NULL, x varchar(20) NOT NULL, y varchar(20) NOT NULL, z varchar(20) NOT NULL, permissao varchar(100) NOT NULL, nome_craft varchar(100) NOT NULL, CONSTRAINT NewTable_pk PRIMARY KEY (id)) ;")


--========================================================================================================================

vRP.prepare("vRP/get_vehicles_no_vip", "SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vip = false")
vRP.prepare("vRP/insert_trucker",
	"INSERT INTO trucker_trucks (user_id, truck_name, driver) VALUES(@user_id, @vehicle, 0)")


vRP.prepare("vRP/get_vehicles_player",
	"SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vip = false AND work = 'false'")
vRP.prepare("vRP/get_vehicles_price",
	"SELECT * FROM monkey_concessionaria WHERE carro = @carro")
vRP.prepare("vRP/get_vehicles_sell",
	"DELETE FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND plate = @plate")
vRP.prepare("vRP/get_vehicles_transfer",
	"UPDATE vrp_vehicles SET user_id = @user_id WHERE vehicle = @vehicle AND plate = @plate")

vRP.prepare("vRP/get_vehicles_db", "SELECT * FROM monkey_concessionaria")

--========================================================================================================================


function cnVRP.TodosVeiculos()
	local veiculos = {}
	local carro = vRP.execute("vRP/get_vehicles_db")
	local indice = 0
	for k, v in pairs(carro) do

		indice = indice + 1
		if indice <= #carro then
			local car = {
				["nome"] = v.carro,
				["nome_vitrine"] = v.nomeVitrine,
				["preco"] = v.valor,
				["kg"] = v.peso
			}
			table.insert(veiculos, car)
		end
	end

	return veiculos
end

function cnVRP.getCarrosPlayer()
	local source = source
	local id_user = vRP.getUserId(source)
	local carrosPlayer = vRP.execute("vRP/get_vehicles_player", { user_id = id_user })
	local conc = {}

	lista_carros.carros = {}
	local indice = 0
	for k, v in pairs(carrosPlayer) do
		conc = vRP.execute("vRP/get_vehicles_price", { carro = v.vehicle })
		if #conc < 1 then
			valor = 0
		else
			valor = conc[1].valor * Config.porcentagem_venda
		end
		indice = indice + 1
		if indice <= #carrosPlayer then
			local item = {
				['nomeVitrine'] = conc[1].nomeVitrine,
				["nomeCarro"] = v.vehicle,
				["placaCarro"] = v.plate,
				["carroDetido"] = v.detido,
				["valor"] = valor
			}
			table.insert(v, k)
			lista_carros.carros[indice] = item
		end
	end
	return lista_carros
end

--============================================================================================================================

function cnVRP.getVehiclesSell(vehicle, plate, valor)
	local source = source
	local id_user = vRP.getUserId(source)
	vRP.execute("vRP/get_vehicles_sell", { user_id = id_user, vehicle = vehicle, plate = plate })
	local infoPlayer = vRP.getInformation(id_user)
	local banco = infoPlayer[1].bank + valor
	vRP.setBank(id_user, banco)

	local carrosPlayer = vRP.execute("vRP/get_vehicles_player", { user_id = id_user })
	local conc = {}

	lista_carros.carros = {}
	local indice = 0
	for k, v in pairs(carrosPlayer) do
		conc = vRP.execute("vRP/get_vehicles_price", { carro = v.vehicle })
		if #conc < 1 then
			valor = 0
		else
			valor = conc[1].valor * Config.porcentagem_venda
		end
		indice = indice + 1
		if indice <= #carrosPlayer then
			local item = {
				['nomeVitrine'] = conc[1].nomeVitrine,
				["nomeCarro"] = v.vehicle,
				["placaCarro"] = v.plate,
				["carroDetido"] = v.detido,
				["valor"] = valor
			}
			table.insert(v, k)
			lista_carros.carros[indice] = item
		end
	end
	return lista_carros
end

--============================================================================================================================

function cnVRP.getVehiclesTransfer(vehicle, plate, id_transfer)
	local source = source
	local id_user = vRP.getUserId(source)
	local infoPlayer = vRP.getInformation(id_transfer)
	local qtdcarros = vRP.execute("vRP/get_vehicles_player", { user_id = id_transfer })
	if #qtdcarros + 1 <= parseInt(infoPlayer[1].garage) then
		vRP.execute("vRP/get_vehicles_transfer", { user_id = id_transfer, vehicle = vehicle, plate = plate })

		local carrosPlayer = vRP.execute("vRP/get_vehicles_player", { user_id = id_user })
		local conc = {}

		lista_carros.carros = {}
		local indice = 0
		for k, v in pairs(carrosPlayer) do
			conc = vRP.execute("vRP/get_vehicles_price", { carro = v.vehicle })
			if #conc < 1 then
				valor = 0
			else
				valor = conc[1].valor * Config.porcentagem_venda
			end
			indice = indice + 1
			if indice <= #carrosPlayer then
				local item = {
					['nomeVitrine'] = conc[1].nomeVitrine,
					["nomeCarro"] = v.vehicle,
					["placaCarro"] = v.plate,
					["carroDetido"] = v.detido,
					["valor"] = valor
				}
				table.insert(v, k)
				lista_carros.carros[indice] = item
			end
		end
		return lista_carros
	else
		local carrosPlayer = vRP.execute("vRP/get_vehicles_player", { user_id = id_user })
		local conc = {}
		TriggerClientEvent("Notify", source, "importante", "Sem espaço na garagem!", 5000)
		lista_carros.carros = {}
		local indice = 0
		for k, v in pairs(carrosPlayer) do
			conc = vRP.execute("vRP/get_vehicles_price", { carro = v.vehicle })
			if #conc < 1 then
				valor = 0
			else
				valor = conc[1].valor * Config.porcentagem_venda
			end
			indice = indice + 1
			if indice <= #carrosPlayer then
				local item = {
					['nomeVitrine'] = conc[1].nomeVitrine,
					["nomeCarro"] = v.vehicle,
					["placaCarro"] = v.plate,
					["carroDetido"] = v.detido,
					["valor"] = valor
				}
				table.insert(v, k)
				lista_carros.carros[indice] = item
			end
		end
		return lista_carros
	end
end

function cnVRP.insertVehicleOnGarage(vehicle, preco)

	local source = source
	local user_id = vRP.getUserId(source)

	local name = vehicle
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local vehName = tostring(name)
		local vehPlate = vRP.vehList(source, 11)
		local todos_veiculos_nao_vip = vRP.query("vRP/get_vehicles_no_vip", { user_id = parseInt(user_id) })
		local myGarages = vRP.getInformation(user_id)
		local plateId = vRP.getVehiclePlate(vehPlate)

		local getInvoice = vRP.getInvoice(user_id)
		if getInvoice[1] ~= nil then
			TriggerClientEvent("Notify", source, "vermelho", "Encontramos faturas pendentes.", 3000)
			return false
		else

			if vRP.vehicleType(name) ~= "work" then
				if parseInt(#todos_veiculos_nao_vip) >= parseInt(myGarages[1].garage) then
					TriggerClientEvent("Notify", source, "amarelo", "Você atingiu o máximo de veículos em sua garagem.", 3000)
					return false
				else
					local vehicle = vRP.query("vRP/get_vehicles", { user_id = parseInt(user_id), vehicle = vehName })
					if vehicle[1] then
						TriggerClientEvent("Notify", source, "amarelo", "Você já possui um <b>" .. vehName .. "</b>.", 3000)
						return false
					else

						if vRP.paymentBank(user_id, parseInt(preco)) then
							addToTruckerTrucks(user_id, vehName)
							local placa_nova = vRP.generatePlateNumber()
							vRP.execute("vRP/add_vehicle",
								{ user_id = parseInt(user_id), vehicle = vehName, plate = placa_nova, phone = vRP.getPhone(user_id),
									work = tostring(false) })
							-- vRP.execute("vRP/set_arrest",{ user_id = parseInt(user_id), vehicle = name, arrest = 1, time = parseInt(os.time()) })
							TriggerClientEvent("Notify", source, "verde", "A compra foi concluída com sucesso.", 5000)
							return true
						else
							TriggerClientEvent("Notify", source, "vermelho", "Dinheiro insuficiente na sua conta bancária.", 5000)
							return false
						end

					end

				end


			else
				TriggerClientEvent("Notify", source, "amarelo", "Esse veiculos é de trabalho, avise a prefeitura. NOME: " .. name,
					20000)
				return false
			end
		end

	end
end

function addToTruckerTrucks(user_id, name)
	if name == "actros" or name == "man" or name == "daf" or name == "t680" or name == "w900" or name == "vnl780" then
		vRP.execute("vRP/insert_trucker", { user_id = parseInt(user_id), vehicle = name })
	end
end
