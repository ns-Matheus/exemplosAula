

RegisterCommand("aulaMostrar", function(source, args) 

    SendNUIMessage({ acao = "tela", mostrar = true })
    SetNuiFocus(true,true)

end)

RegisterCommand("aulaEsconder", function(source, args) 

    SendNUIMessage({ acao = "tela", mostrar = false })
    SetNuiFocus(false,false)

end)

--SetNuiFocus(false,false)

RegisterNUICallback("fechar",function(data, cb)
	
    local h = data.titulo

    print(h)

    cb({hg = "teste de reotnor sei lá"})

end)