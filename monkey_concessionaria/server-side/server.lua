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
       
        local car = {
            ["nome"] = k,
            ["nome_vitrine"] = v[1],
            ["preco"] = v[3],
            ["kg"] = v[2]
        }
        table.insert(veiculos,car)

    end

    return veiculos
end


