local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

emP = Tunnel.getInterface("monkey_rotanortesul")
cRP = {}
Tunnel.bindInterface("rotanortesul", cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local inPed = nil
local selecionado = 1
local quantidade = 0
local setar_novo_destino = false
local time_co = 0

local rota_selecionada = nil

local subornos = nil

local locs = {}

local pedHashs = {
	"u_m_m_streetart_01",
	"u_m_m_streetart_01",
	"u_m_m_streetart_01"
}

local pedHashsX = {
	"ig_abigail",
	"u_m_y_abner",
	"a_m_o_acult_02",
	"a_m_m_afriamer_01",
	"csb_mp_agent14",
	"csb_agent",
	"u_m_m_aldinapoli",
	"ig_amandatownley",
	"ig_andreas",
	"u_m_y_antonb",
	"csb_anita",
	"cs_andreas",
	"ig_ashley",
	"s_m_m_autoshop_01",
	"ig_money",
	"g_m_y_ballaeast_01",
	"g_m_y_ballaorig_01",
	"g_f_y_ballas_01",
	"u_m_y_babyd",
	"ig_barry",
	"s_m_y_barman_01",
	"u_m_y_baygor",
	"a_f_y_beach_01",
	"a_f_y_bevhills_02",
	"a_f_y_bevhills_01",
	"u_m_y_burgerdrug_01",
	"a_m_m_business_01",
	"a_f_m_business_02",
	"a_m_y_business_02",
	"ig_car3guy1",
	"ig_chef2",
	"g_m_m_chigoon_02",
	"g_m_m_chigoon_01",
	"ig_claypain",
	"ig_clay",
	"a_f_m_eastsa_01"
}

Citizen.CreateThread(function()
	while true do
		if servico then

			if inPed == nil then
				Citizen.Wait(math.random(5, 20))

				local mHash = GetHashKey(pedHashs[math.random(#pedHashs)])

				RequestModel(mHash)
				while not HasModelLoaded(mHash) do
					RequestModel(mHash)
					Citizen.Wait(10)
				end

				local rand = selecionado
				-- print(locs[rand].x)
				-- print(locs[rand].y)
				-- print(locs[rand].z)
				-- print(locs[rand].grau)
				inPed = CreatePed(4, mHash, locs[rand].x, locs[rand].y, locs[rand].z - 1, locs[rand].grau, false, false)
				SetEntityInvincible(inPed, true)
				FreezeEntityPosition(inPed, true)
				SetPedSuffersCriticalHits(inPed, false)
				SetBlockingOfNonTemporaryEvents(inPed, true)
				SetModelAsNoLongerNeeded(mHash)

			end
		end
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if servico then

			timeDistance = 5

			drawTxt("PRESSIONE ~g~F7 ~w~PARA FINALIZAR O EXPEDIENTE", 4, 0.260, 0.905, 0.5, 255, 255, 255, 200)

			if IsControlJustPressed(0, 168) then
				if emP.isValido() then
					TriggerEvent("Notify", "importante", "Você saiu de serviço")
					servico = false

					if DoesBlipExist(blips) then
						RemoveBlip(blips)
						blips = nil
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local time = 1000
		if not servico then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			for k, value in pairs(Config.locais_iniciar) do
				local distance = #(coords - vector3(value.x, value.y, value.z))
				if distance <= 5 then
					time = 1
					DrawMarker(21, value.x, value.y, value.z - 0.5, 0, 0, 0, 0.0, 0, 0, 0.5, 0.5, 0.4, 255, 0, 0, 50, 0, 0, 0, 1)
					if distance <= 1.2 then
						drawTxt("PRESSIONE  ~r~E~w~  PARA INICIAR AS ROTAS", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
						if IsControlJustPressed(0, 38) then
							if emP.isValido() then
								if value.permissao == "public" or emP.checkPermission(value.permissao) then

									rota_selecionada = nil

									if subornos == nil then
										subornos = Config.rotas

										for j, v in pairs(subornos) do
											for h, u in pairs(subornos[j]) do
												subornos[j][h].indice_pai = j
												subornos[j][h].indice_filho = h
											end
										end

									end

									SendNUIMessage({
										show = true,
										rotas = subornos[value.tipo]
									})
									SetNuiFocus(true, true)


								else
									TriggerEvent("Notify", "importante", "Não tem permissão.", 5000)

								end
							end
						end
					end
				end

			end


		end
		Citizen.Wait(time)
	end
end)

Citizen.CreateThread(function()
	while true do
		if servico and setar_novo_destino then
			async(function()
				deletar_antigo_ped(inPed)
			end)
			inPed = nil
			setar_novo_destino = false
		end
		Citizen.Wait(1000)
	end
end)

function deletar_antigo_ped(pedA)
	Citizen.Wait(20000)
	DeleteEntity(pedA)
end

Citizen.CreateThread(function()
	while true do
		time_co = time_co - 1
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local time = 1000
		if servico then
			local ped = PlayerPedId()
			local x, y, z = table.unpack(GetEntityCoords(ped))
			local bowz, cdz = GetGroundZFor_3dCoord(locs[selecionado].x, locs[selecionado].y, locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x, locs[selecionado].y, cdz, x, y, z, true)
			local vehicle = GetPlayersLastVehicle()
			if distance <= 15 then
				time = 1
				-- DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 2.0 then
					drawTxt("PRESSIONE  ~r~E~w~  PARA COLETAR A ENCOMENDA", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
					if IsControlJustPressed(0, 38) and time_co < 0 then
						if emP.isValido() then
							-- if IsVehicleModel(vehicle,GetHashKey("nemesis")) and not IsPedInAnyVehicle(ped) then

							local pags = rota_selecionada

							for k, value in pairs(pags.itens) do
								local qtd_r = math.random(value.qtd_min, value.qtd_max)
								if qtd_r > 0 then
									emP.checkPayment(value.item, qtd_r, pags.police, x, y, z)
								end
							end

							RemoveBlip(blips)
							backentrega = selecionado
							-- print("selecionado "..selecionado.." #locs "..#locs)
							if selecionado == #locs then
								selecionado = 1
							else
								selecionado = selecionado + 1
							end

							FreezeEntityPosition(inPed, false)
							TaskWanderStandard(inPed, 10.0, 10)
							setar_novo_destino = true
							time_co = 10

							CriandoBlip(locs, selecionado)
							TriggerEvent("Notify", "importante", "Vá até o próximo local e colete as encomendas.", 5000)
						end
					end
				end
			end
		end
		Citizen.Wait(time)
	end
end)

RegisterNUICallback("pagarSuborno", function(data, cb)
	if emP.checkItem2(Config.item_suborno, data.valor_suborno) then
		subornos[data.indice_pai][data.indice_filho].police = subornos[data.indice_pai][data.indice_filho].police - 1
		cb({ rotas = subornos[data.indice_pai], msg = "Suborno pago com sucesso", pagamento = true })
	else
		cb({ rotas = subornos[data.indice_pai],
			msg = "Você precisa de " .. data.valor_suborno .. " de " .. Config.item_suborno_vitrine .. " para pagar suborno",
			pagamento = false })
	end
end)


RegisterNUICallback("sair", function(data)
	SetNuiFocus(false, false)
end)

RegisterNUICallback("setarRota", function(data)
	rota_selecionada = data
end)

RegisterNUICallback("iniciarRotaSul", function(data)

	if rota_selecionada == nil then
		TriggerEvent("Notify", "importante", "Seleciona o tipo de rota.", 5000)
	else

		local pode_iniciar = false

		if rota_selecionada.requisito == nil then
			pode_iniciar = true
		else
			if emP.checkItem(rota_selecionada.requisito, 1) then
				pode_iniciar = true
			end
		end

		if pode_iniciar then

			local random = math.random(1, 3)

			if random == 1 then
				locs = Config.locsSul1
			end
			if random == 2 then
				locs = Config.locsSul2
			end
			if random == 3 then
				locs = Config.locsSul3
			end

			selecionado = 1

			servico = true

			CriandoBlip(locs, selecionado)

			TriggerEvent("Notify", "sucesso", "Você entrou em serviço da rota sul.", 1500)
			TriggerEvent("Notify", "importante", "Vá até o próximo local e colete as encomendas.", 5000)

			SetNuiFocus(false, false)
		end
	end
end)

RegisterNUICallback("iniciarRotaNorte", function()
	
	local pode_iniciar = false
	if rota_selecionada == nil then
		TriggerEvent("Notify", "importante", "Seleciona o tipo de rota.", 5000)
	else

		
		if rota_selecionada.requisito == nil then
			pode_iniciar = true
		else
			if emP.checkItem(rota_selecionada.requisito, 1) then
				pode_iniciar = true
			end
		end
	end

	if pode_iniciar then
			
		local random = math.random(1, 3)

		if random == 1 then
			locs = Config.locsNorte1
		end
		if random == 2 then
			locs = Config.locsNorte2
		end
		if random == 3 then
			locs = Config.locsNorte3
		end
		if random == 1 then
			locs = locsNorte1
		end
		if random == 2 then
			locs = locsNorte2
		end
		if random == 3 then
			locs = locsNorte3
		end

		servico = true

		CriandoBlip(locs, selecionado)

		TriggerEvent("Notify", "sucesso", "Você entrou em serviço da rota norte.", 500)
		TriggerEvent("Notify", "importante", "Vá até o próximo local e colete as encomendas.", 5000)

		SetNuiFocus(false, false)
	end

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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

function CriandoBlip(locs, selecionado)
	blips = AddBlipForCoord(locs[selecionado].x, locs[selecionado].y, locs[selecionado].z)
	SetBlipSprite(blips, 1)
	SetBlipColour(blips, 5)
	SetBlipScale(blips, 0.4)
	SetBlipAsShortRange(blips, false)
	SetBlipRoute(blips, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Leite")
	EndTextCommandSetBlipName(blips)
end
