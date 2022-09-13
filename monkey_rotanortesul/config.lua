Config = {}

Config.item_suborno = "dollars2"
Config.item_suborno_vitrine = "Dinheiro Sujo"

Config.perm_police = "Police"

Config.rotas = {

	["fac"] = {
		["lavagem"] = {
			["nome"] = "Rota Lavagem",
			["requisito"] = "redcard",
			["police"] = 5,
			["valor_suborno"] = 12000,
			["itens"] = {
				[1] = { ["item"] = "papelmoeda" , ["qtd_min"] = 1 , ["qtd_max"] = 1 },
				[2] = { ["item"] = "elastic" , ["qtd_min"] = 0 , ["qtd_max"] = 5 }
			}
		},
		["arma"] = {
			["nome"] = "Rota Armas",
			["requisito"] = "bluecard",
			["police"] = 4,
			["valor_suborno"] = 12000,
			["itens"] = {
				[1] = { ["item"] = "cartucho" , ["qtd_min"] = 0 , ["qtd_max"] = 5 },
				[2] = { ["item"] = "pecadearma" , ["qtd_min"] = 0 , ["qtd_max"] = 3 },
			}
		},
		["eletronic"] = {
			["nome"] = "Rota Eletrônicos",
			["requisito"] = nil,
			["police"] = 2,
			["valor_suborno"] = 2000,
			["itens"] = {
				[1] = { ["item"] = "keyboard" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
				[2] = { ["item"] = "mouse" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
				[3] = { ["item"] = "watch" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
				[4] = { ["item"] = "playstation" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
				[5] = { ["item"] = "xbox" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
				[6] = { ["item"] = "cpuchip" , ["qtd_min"] = 0 , ["qtd_max"] = 1 },
			}
		},
		["plastic"] = {
			["nome"] = "Rota Plásticos",
			["requisito"] = nil,
			["police"] = 1,
			["valor_suborno"] = 1000,
			["itens"] = {
				[1] = { ["item"] = "legos" , ["qtd_min"] = 5 , ["qtd_max"] = 7 },
				[2] = { ["item"] = "ominitrix" , ["qtd_min"] = 5 , ["qtd_max"] = 7 }
			}
		}
	},
	["drogas"] = {
		["cocaina"] = {
			["nome"] = "Rota Cocaina",
			["requisito"] = nil,
			["police"] = 2,
			["valor_suborno"] = 2000,
			["itens"] = {
				[1] = { ["item"] = "farinha" , ["qtd_min"] = 1 , ["qtd_max"] = 2 },
			}
		},
		["maconha"] = {
			["nome"] = "Rota Maconha",
			["requisito"] = nil,
			["police"] = 1,
			["valor_suborno"] = 2000,
			["itens"] = {
				[1] = { ["item"] = "cannabisseed" , ["qtd_min"] = 1 , ["qtd_max"] = 2 }
			}
		},
		["estasy"] = {
			["nome"] = "Rota de Estasy",
			["requisito"] = nil,
			["police"] = 2,
			["valor_suborno"] = 2000,
			["itens"] = {
				[1] = { ["item"] = "doril" , ["qtd_min"] = 1 , ["qtd_max"] = 2 }
			}
		},
		["meta"] = {
			["nome"] = "Rota de Meta",
			["requisito"] = nil,
			["police"] = 5,
			["valor_suborno"] = 4000,
			["itens"] = {
				[1] = { ["item"] = "anador" , ["qtd_min"] = 1 , ["qtd_max"] = 2 }
			}
		},
		["lean"] = {
			["nome"] = "Rota de Lean",
			["requisito"] = nil,
			["police"] = 3,
			["valor_suborno"] = 2000,
			["itens"] = {
				[1] = { ["item"] = "xarope" , ["qtd_min"] = 1 , ["qtd_max"] = 2 },
			}
		}
	 },
	 ["mochila"] = {
		["mochila"] = {
			["nome"] = "Rota de Pano e Linha",
			["requisito"] = nil,
			["police"] = 0,
			["valor_suborno"] = 0,
			["itens"] = {
				[1] = { ["item"] = "pano" , ["qtd_min"] = 1 , ["qtd_max"] = 2 },
				[2] = { ["item"] = "linha" , ["qtd_min"] = 1 , ["qtd_max"] = 2 }
			}
		}
	 }
	
}

Config.locais_iniciar = {
	[1] = { ['x'] = -1800.7299804688, ['y'] = -1205.83984375, ['z'] = 14.305000305176, ["permissao"] = "public", ["tipo"] = "drogas" },
	[2] = { ['x'] =  701.14666748047, ['y'] = -979.24163818359, ['z'] = 23.651491165161, ["permissao"] = "public", ["tipo"] = "mochila" },
	[3] = { ['x'] = -3199.2053222656, ['y'] = 840.26239013672, ['z'] = 8.93492603302, ["permissao"] = "rota", ["tipo"] = "fac" },
	[4] = { ['x'] = -876.00665283203, ['y'] = -1460.8253173828, ['z'] = 7.5268049240112, ["permissao"] = "yakuza@10", ["tipo"] = "fac" },
	[5] = { ['x'] = -2676.7995605469, ['y'] = 1328.0137939453, ['z'] = 140.88143920898, ["permissao"] = "cartel@10", ["tipo"] = "fac" },
	[6] = { ['x'] = -1866.3018798828, ['y'] = 2061.6755371094, ['z'] = 135.43464660645, ["permissao"] = "irmandade@10", ["tipo"] = "fac" },
	[7] = { ['x'] = -3225.6171875, ['y'] = 816.6552734375, ['z'] = 14.077815055847, ["permissao"] = "syndicato@10", ["tipo"] = "fac" },
	[8] = { ['x'] = 97.338897705078, ['y'] = -1292.0897216797, ['z'] = 29.268741607666, ["permissao"] = "vanilla@10", ["tipo"] = "fac" },
	[9] = { ['x'] = 989.52038574219, ['y'] = -97.214576721191, ['z'] = 74.845062255859, ["permissao"] = "thelost2@10", ["tipo"] = "fac" },
	[10] = { ['x'] = -1382.1953125, ['y'] = -622.25720214844, ['z'] = 30.819568634033, ["permissao"] = "bahama@10", ["tipo"] = "fac" },
	[11] = { ['x'] = -561.96606445313, ['y'] = 285.94479370117, ['z'] = 85.376518249512,  ["permissao"] = "tequila@10", ["tipo"] = "fac" },
	[13] = { ['x'] = -811.16125488281, ['y'] = 246.02139282227, ['z'] = 79.196174621582, ["permissao"] = "cupula@10", ["tipo"] = "fac" },
	[12] = { ['x'] = -802.7998046875, ['y'] = 172.49610900879, ['z'] = 72.844650268555, ["permissao"] = "guilda@10", ["tipo"] = "fac" },
	[14] = { ['x'] = -1478.9554443359, ['y'] = -45.958026885986, ['z'] = 57.421676635742, ["permissao"] = "ava@10", ["tipo"] = "fac" },
	[15] = { ['x'] = -1500.2446289063, ['y'] = 125.07995605469, ['z'] = 55.668102264404, ["permissao"] = "roma@10", ["tipo"] = "fac" },
	[16] = { ['x'] = -1122.0837402344, ['y'] = 362.82803344727, ['z'] = 71.307052612305, ["permissao"] = "zero@10", ["tipo"] = "fac" },
	[17] = { ['x'] = -1726.6423339844, ['y'] = 378.98211669922, ['z'] = 89.723899841309, ["permissao"] = "hydra@10", ["tipo"] = "fac" },
	[18] = { ['x'] = -733.69879150391, ['y'] = 504.44613647461, ['z'] = 109.56745910645, ["permissao"] = "division@10", ["tipo"] = "fac" },
	[19] = { ['x'] = 141.99833679199, ['y'] = 337.54229736328, ['z'] = 116.60819244385, ["permissao"] = "thelost@10", ["tipo"] = "fac" },
	[20] = { ['x'] = -534.89581298828, ['y'] = 508.28628540039, ['z'] = 112.4440612793, ["permissao"] = "rikers@10", ["tipo"] = "fac" },
	[21] = { ['x'] = -717.10443115234, ['y'] = 634.03900146484, ['z'] = 159.18751525879, ["permissao"] = "triade@10", ["tipo"] = "fac" },
	[22] = { ['x'] = -106.45559692383, ['y'] = 981.40441894531, ['z'] = 240.84283447266, ["permissao"] = "comandosul@10", ["tipo"] = "fac" },
	[23] = { ['x'] = 1.7276377677917, ['y'] = 525.20031738281, ['z'] = 170.61723327637, ["permissao"] = "capital@10", ["tipo"] = "fac" },
	[24] = { ['x'] = -87.354537963867, ['y'] = 835.83416748047, ['z'] = 227.78504943848, ["permissao"] = "cdl@10", ["tipo"] = "fac" },
	[25] = { ['x'] = 1393.9930419922, ['y'] = 1163.3516845703, ['z'] = 114.3335723877, ["permissao"] = "galo@10", ["tipo"] = "fac" },
	[26] = { ['x'] = 5011.2270507813, ['y'] = -5753.3095703125, ['z'] = 28.845275878906, ["permissao"] = "gtm@10", ["tipo"] = "fac" },
	[27] = { ['x'] = -1826.5667724609, ['y'] = -1197.2237548828, ['z'] = 19.420883178711, ["permissao"] = "pearls@10", ["tipo"] = "fac" },
}



Config.locsSul1 = {
	[1] = { ['x'] = -1351.7781982422, ['y'] = -756.53564453125, ['z'] = 22.374307632446, ['grau'] = 315.42825317383},
	[2] = { ['x'] = -1263.6118164063, ['y'] = -1117.4351806641, ['z'] = 7.6678204536438, ['grau'] = 96.368789672852},
	[3] = { ['x'] = -718.63543701172, ['y'] = -1119.8221435547, ['z'] = 10.652391433716, ['grau'] = 291.78277587891},
	[4] = { ['x'] = -179.01011657715, ['y'] = -1256.9222412109, ['z'] = 31.295961380005, ['grau'] = 68.29468536377},
	[5] = { ['x'] = -15.331567764282, ['y'] = -838.837890625, ['z'] = 30.5022315979, ['grau'] = 248.01542663574},
	[6] = { ['x'] = -5.5589580535889, ['y'] = -202.91044616699, ['z'] = 52.679546356201, ['grau'] = 148.3649597168},
	[7] = { ['x'] = 144.23774719238, ['y'] = -131.49507141113, ['z'] = 54.826519012451, ['grau'] = 331.79580688477},
	[8] = { ['x'] = 436.12783813477, ['y'] = 214.90257263184, ['z'] = 103.16603851318, ['grau'] = 324.05227661133},
	[9] = { ['x'] = 169.98489379883, ['y'] = 481.20840454102, ['z'] = 142.14237976074, ['grau'] = 303.57656860352},
	[10] = { ['x'] = -559.08801269531, ['y'] = 663.78643798828, ['z'] = 145.4868927002, ['grau'] = 313.19055175781},
	[11] = { ['x'] = -658.47979736328, ['y'] = 886.45281982422, ['z'] = 229.24909973145, ['grau'] = 10.936609268188},
	[12] = { ['x'] = -338.04559326172, ['y'] = 630.25640869141, ['z'] = 172.35360717773, ['grau'] = 55.105480194092},
	[13] = { ['x'] = -174.76672363281, ['y'] = 219.09790039063, ['z'] = 90.012641906738, ['grau'] = 186.46469116211},
	[14] = { ['x'] = -567.76727294922, ['y'] = -441.85809326172, ['z'] = 34.355995178223, ['grau'] = 167.95175170898},
	[15] = { ['x'] = -1567.3747558594, ['y'] = -979.82995605469, ['z'] = 13.01743888855, ['grau'] = 192.34909057617},
	[16] = { ['x'] = -1165.1290283203, ['y'] = -1234.8416748047, ['z'] = 6.7705140113831, ['grau'] = 286.95425415039},
	[17] = { ['x'] = -671.02252197266, ['y'] = -1185.5510253906, ['z'] = 10.612627983093, ['grau'] = 304.96591186523},
	[18] = { ['x'] = -456.06488037109, ['y'] = -932.88043212891, ['z'] = 23.66429901123, ['grau'] = 354.61737060547},
	[19] = { ['x'] = 733.45135498047, ['y'] = -562.07415771484, ['z'] = 26.900974273682, ['grau'] = 72.375877380371},
	[20] = { ['x'] = 225.90409851074, ['y'] = -9.3142547607422, ['z'] = 73.788566589355, ['grau'] = 348.86331176758},
	[21] = { ['x'] = -739.51513671875, ['y'] = -279.50381469727, ['z'] = 36.949062347412, ['grau'] = 276.93579101563},
	[22] = { ['x'] = -1192.1348876953, ['y'] = -466.38153076172, ['z'] = 33.363464355469, ['grau'] = 293.08392333984},
	[23] = { ['x'] = -1382.5362548828, ['y'] = -653.17834472656, ['z'] = 28.681547164917, ['grau'] = 305.20309448242},
	[24] = { ['x'] = -1687.7232666016, ['y'] = -461.38461303711, ['z'] = 40.374767303467, ['grau'] = 311.16500854492},
	[25] = { ['x'] = -1901.6998291016, ['y'] = -334.5061340332, ['z'] = 49.238235473633, ['grau'] = 305.18511962891},
}

Config.locsSul2 = {
	[1] = { ['x'] = -594.69293212891, ['y'] = 37.56510925293, ['z'] = 43.607715606689, ['grau'] = 185.99130249023},
	[2] = { ['x'] = -196.0390625, ['y'] = 16.772659301758, ['z'] = 56.312023162842, ['grau'] = 158.98460388184},
	[3] = { ['x'] = 153.58177185059, ['y'] = -118.83893585205, ['z'] = 54.825958251953, ['grau'] = 152.30215454102},
	[4] = { ['x'] = 706.72692871094, ['y'] = -304.3388671875, ['z'] = 59.24564743042, ['grau'] = 2.3011996746063},
	[5] = { ['x'] = 1082.5717773438, ['y'] = -787.96429443359, ['z'] = 58.262699127197, ['grau'] = 183.2951965332},
	[6] = { ['x'] = 1213.6518554688, ['y'] = -1262.2803955078, ['z'] = 35.22673034668, ['grau'] = 82.818359375},
	[7] = { ['x'] = 1437.2021484375, ['y'] = -1492.6359863281, ['z'] = 63.622009277344, ['grau'] = 156.50651550293},
	[8] = { ['x'] = 1480.6956787109, ['y'] = -1915.8173828125, ['z'] = 71.45832824707, ['grau'] = 196.15998840332},
	[9] = { ['x'] = 1265.8275146484, ['y'] = -2568.6252441406, ['z'] = 42.986694335938, ['grau'] = 5.7246766090393},
	[10] = { ['x'] = 1018.4866333008, ['y'] = -2511.6923828125, ['z'] = 28.473373413086, ['grau'] = 83.347763061523},
	[11] = { ['x'] = 854.86004638672, ['y'] = -2112.8913574219, ['z'] = 31.575571060181, ['grau'] = 174.61024475098},
	[12] = { ['x'] = 428.29150390625, ['y'] = -1964.5729980469, ['z'] = 23.346639633179, ['grau'] = 298.1960144043},
	[13] = { ['x'] = 135.8219909668, ['y'] = -2196.5893554688, ['z'] = 6.1711993217468, ['grau'] = 344.92761230469},
	[14] = { ['x'] = -272.62753295898, ['y'] = -2214.0756835938, ['z'] = 10.052577972412, ['grau'] = 138.97766113281},
	[15] = { ['x'] = -684.48840332031, ['y'] = -2233.5546875, ['z'] = 5.9458599090576, ['grau'] = 277.99835205078},
	[16] = { ['x'] = -896.60131835938, ['y'] = -2390.8383789063, ['z'] = 14.024357795715, ['grau'] = 71.121231079102},
	[17] = { ['x'] = -559.37567138672, ['y'] = -1804.3455810547, ['z'] = 22.608051300049, ['grau'] = 333.85015869141},
	[18] = { ['x'] = -753.35369873047, ['y'] = -1512.1479492188, ['z'] = 5.0181746482849, ['grau'] = 5.2214126586914},
	[19] = { ['x'] = -862.55718994141, ['y'] = -1227.5563964844, ['z'] = 6.4591174125671, ['grau'] = 320.21792602539},
	[20] = { ['x'] = -1038.1312255859, ['y'] = -1397.240234375, ['z'] = 5.5531921386719, ['grau'] = 79.817581176758},
	[21] = { ['x'] = -1129.8079833984, ['y'] = -1604.5465087891, ['z'] = 4.3984251022339, ['grau'] = 220.65837097168},
	[22] = { ['x'] = -1227.6787109375, ['y'] = -1234.3570556641, ['z'] = 7.0479846000671, ['grau'] = 17.377130508423},
	[23] = { ['x'] = -1615.9976806641, ['y'] = -985.17785644531, ['z'] = 7.6198163032532, ['grau'] = 149.63020324707},
	[24] = { ['x'] = -2213.6350097656, ['y'] = -370.89556884766, ['z'] = 13.320317268372, ['grau'] = 27.407562255859},
	[25] = { ['x'] = -1972.6510009766, ['y'] = -297.33987426758, ['z'] = 48.106151580811, ['grau'] = 108.57595062256},
}

Config.locsSul3 = {
	[1] = { ['x'] = -594.69293212891, ['y'] = 37.56510925293, ['z'] = 43.607715606689, ['grau'] = 185.99130249023},
	[2] = { ['x'] = -196.0390625, ['y'] = 16.772659301758, ['z'] = 56.312023162842, ['grau'] = 158.98460388184},
	[3] = { ['x'] = 153.58177185059, ['y'] = -118.83893585205, ['z'] = 54.825958251953, ['grau'] = 152.30215454102},
	[4] = { ['x'] = 706.72692871094, ['y'] = -304.3388671875, ['z'] = 59.24564743042, ['grau'] = 2.3011996746063},
	[5] = { ['x'] = 1082.5717773438, ['y'] = -787.96429443359, ['z'] = 58.262699127197, ['grau'] = 183.2951965332},
	[6] = { ['x'] = 1213.6518554688, ['y'] = -1262.2803955078, ['z'] = 35.22673034668, ['grau'] = 82.818359375},
	[7] = { ['x'] = 1437.2021484375, ['y'] = -1492.6359863281, ['z'] = 63.622009277344, ['grau'] = 156.50651550293},
	[8] = { ['x'] = 1480.6956787109, ['y'] = -1915.8173828125, ['z'] = 71.45832824707, ['grau'] = 196.15998840332},
	[9] = { ['x'] = 1265.8275146484, ['y'] = -2568.6252441406, ['z'] = 42.986694335938, ['grau'] = 5.7246766090393},
	[10] = { ['x'] = 1018.4866333008, ['y'] = -2511.6923828125, ['z'] = 28.473373413086, ['grau'] = 83.347763061523},
	[11] = { ['x'] = 854.86004638672, ['y'] = -2112.8913574219, ['z'] = 31.575571060181, ['grau'] = 174.61024475098},
	[12] = { ['x'] = 428.29150390625, ['y'] = -1964.5729980469, ['z'] = 23.346639633179, ['grau'] = 298.1960144043},
	[13] = { ['x'] = 135.8219909668, ['y'] = -2196.5893554688, ['z'] = 6.1711993217468, ['grau'] = 344.92761230469},
	[14] = { ['x'] = -272.62753295898, ['y'] = -2214.0756835938, ['z'] = 10.052577972412, ['grau'] = 138.97766113281},
	[15] = { ['x'] = -684.48840332031, ['y'] = -2233.5546875, ['z'] = 5.9458599090576, ['grau'] = 277.99835205078},
	[16] = { ['x'] = -896.60131835938, ['y'] = -2390.8383789063, ['z'] = 14.024357795715, ['grau'] = 71.121231079102},
	[17] = { ['x'] = -559.37567138672, ['y'] = -1804.3455810547, ['z'] = 22.608051300049, ['grau'] = 333.85015869141},
	[18] = { ['x'] = -753.35369873047, ['y'] = -1512.1479492188, ['z'] = 5.0181746482849, ['grau'] = 5.2214126586914},
	[19] = { ['x'] = -862.55718994141, ['y'] = -1227.5563964844, ['z'] = 6.4591174125671, ['grau'] = 320.21792602539},
	[20] = { ['x'] = -1038.1312255859, ['y'] = -1397.240234375, ['z'] = 5.5531921386719, ['grau'] = 79.817581176758},
	[21] = { ['x'] = -1129.8079833984, ['y'] = -1604.5465087891, ['z'] = 4.3984251022339, ['grau'] = 220.65837097168},
	[22] = { ['x'] = -1227.6787109375, ['y'] = -1234.3570556641, ['z'] = 7.0479846000671, ['grau'] = 17.377130508423},
	[23] = { ['x'] = -1615.9976806641, ['y'] = -985.17785644531, ['z'] = 7.6198163032532, ['grau'] = 149.63020324707},
	[24] = { ['x'] = -2213.6350097656, ['y'] = -370.89556884766, ['z'] = 13.320317268372, ['grau'] = 27.407562255859},
	[25] = { ['x'] = -1972.6510009766, ['y'] = -297.33987426758, ['z'] = 48.106151580811, ['grau'] = 108.57595062256},
}

Config.locsNorte1 = {
	[1] = { ['x'] = 895.76525878906, ['y'] = 3612.9775390625, ['z'] = 32.82420349121, ['grau'] = 171.38639831543},
	[2] = { ['x'] = 346.38018798828, ['y'] = 3406.173828125, ['z'] = 36.493099212646, ['grau'] = 359.71817016602},
	[3] = { ['x'] = 104.69532775879, ['y'] = 3728.0388183594, ['z'] = 39.60860824585, ['grau'] = 124.87143707275},
	[4] = { ['x'] = 257.17358398438, ['y'] = 3091.541015625, ['z'] = 42.464546203613, ['grau'] = 85.915428161621},
	[5] = { ['x'] = -108.85506439209, ['y'] = 2795.5588378906, ['z'] = 53.304096221924, ['grau'] = 284.54577636719},
	[6] = { ['x'] = 506.39016723633, ['y'] = 2611.6027832031, ['z'] = 43.090423583984, ['grau'] = 5.8028583526611},
	[7] = { ['x'] = 1687.8732910156, ['y'] = 3285.9228515625, ['z'] = 41.146511077881, ['grau'] = 257.54241943359},
	[8] = { ['x'] = 1980.3459472656, ['y'] = 3049.8112792969, ['z'] = 50.431865692139, ['grau'] = 148.32388305664},
	[9] = { ['x'] = 2352.4904785156, ['y'] = 2523.4255371094, ['z'] = 47.689392089844, ['grau'] = 313.32684326172},
	[10] = { ['x'] = 2748.423828125, ['y'] = 1453.7683105469, ['z'] = 24.497663497925, ['grau'] = 162.27540588379},
	[11] = { ['x'] = 2709.3203125, ['y'] = 3453.0844726563, ['z'] = 55.536994934082, ['grau'] = 156.50756835938},
	[12] = { ['x'] = 2570.6179199219, ['y'] = 4668.0927734375, ['z'] = 34.076770782471, ['grau'] = 136.08364868164},
	[13] = { ['x'] = 2310.5219726563, ['y'] = 4884.9765625, ['z'] = 41.808227539063, ['grau'] = 41.083232879639},
	[14] = { ['x'] = 1903.7756347656, ['y'] = 4925.9438476563, ['z'] = 48.902908325195, ['grau'] = 240.46661376953},
	[15] = { ['x'] = 1658.0588378906, ['y'] = 4767.6796875, ['z'] = 42.007514953613, ['grau'] = 281.26013183594},
	[16] = { ['x'] = 2223.7841796875, ['y'] = 5604.4833984375, ['z'] = 54.720317840576, ['grau'] = 108.41514587402},
	[17] = { ['x'] = 3311.0922851563, ['y'] = 5176.14453125, ['z'] = 19.614582061768, ['grau'] = 239.11535644531},
	[18] = { ['x'] = 3688.3442382813, ['y'] = 4562.6372070313, ['z'] = 25.183053970337, ['grau'] = 268.50555419922},
	[19] = { ['x'] = 2403.5966796875, ['y'] = 3127.8212890625, ['z'] = 48.152980804443, ['grau'] = 238.79147338867},
	[20] = { ['x'] = 2164.3176269531, ['y'] = 3374.2014160156, ['z'] = 45.351371765137, ['grau'] = 230.48417663574},
	[21] = { ['x'] = 1700.2008056641, ['y'] = 3867.4663085938, ['z'] = 34.897911071777, ['grau'] = 325.9905090332},
}

Config.locsNorte2 = {
	[1] = { ['x'] = 1885.1818847656, ['y'] = 3775.1538085938, ['z'] = 32.786651611328, ['grau'] = 211.46054077148},
	[2] = { ['x'] = 2489.4052734375, ['y'] = 3758.6037597656, ['z'] = 42.253227233887, ['grau'] = 222.5584564209},
	[3] = { ['x'] = 2510.6062011719, ['y'] = 4214.8403320313, ['z'] = 39.931610107422, ['grau'] = 60.168956756592},
	[4] = { ['x'] = 2564.5805664063, ['y'] = 4680.2221679688, ['z'] = 34.077201843262, ['grau'] = 46.827743530273},
	[5] = { ['x'] = 1458.80078125, ['y'] = 6346.248046875, ['z'] = 23.9655418396, ['grau'] = 40.43196105957},
	[6] = { ['x'] = 281.95254516602, ['y'] = 6789.1884765625, ['z'] = 15.695026397705, ['grau'] = 265.57684326172},
	[7] = { ['x'] = -154.45634460449, ['y'] = 6433.8759765625, ['z'] = 31.915897369385, ['grau'] = 204.02239990234},
	[8] = { ['x'] = -668.07861328125, ['y'] = 5812.9116210938, ['z'] = 17.518283843994, ['grau'] = 333.10314941406},
	[9] = { ['x'] = -575.87243652344, ['y'] = 5350.1342773438, ['z'] = 70.214401245117, ['grau'] = 254.86386108398},
	[10] = { ['x'] = -78.033615112305, ['y'] = 6210.5009765625, ['z'] = 31.464805603027, ['grau'] = 235.74139404297},
	[11] = { ['x'] = 1363.9968261719, ['y'] = 6549.2104492188, ['z'] = 14.6075258255, ['grau'] = 358.22113037109},
	[12] = { ['x'] = 2899.4584960938, ['y'] = 4399.3095703125, ['z'] = 50.234760284424, ['grau'] = 217.951171875},
	[13] = { ['x'] = 2634.224609375, ['y'] = 3291.9655761719, ['z'] = 55.728363037109, ['grau'] = 150.47944641113},
	[14] = { ['x'] = 2527.482421875, ['y'] = 2586.283203125, ['z'] = 37.944873809814, ['grau'] = 261.73788452148},
	[15] = { ['x'] = 2357.1472167969, ['y'] = 2608.8107910156, ['z'] = 46.66764831543, ['grau'] = 150.01094055176},
	[16] = { ['x'] = 2368.0229492188, ['y'] = 3156.6044921875, ['z'] = 48.208744049072, ['grau'] = 38.564521789551},
	[17] = { ['x'] = 2175.7138671875, ['y'] = 3321.2316894531, ['z'] = 45.966487884521, ['grau'] = 211.78511047363},
	[18] = { ['x'] = 2271.03515625, ['y'] = 3756.8039550781, ['z'] = 38.424072265625, ['grau'] = 33.857475280762},
	[19] = { ['x'] = 2455.7419433594, ['y'] = 4058.13671875, ['z'] = 38.064720153809, ['grau'] = 245.45184326172},
	[20] = { ['x'] = 2639.6018066406, ['y'] = 4246.1416015625, ['z'] = 44.746807098389, ['grau'] = 36.106880187988},
	[21] = { ['x'] = 2879.8168945313, ['y'] = 4490.9155273438, ['z'] = 48.144878387451, ['grau'] = 159.1071472168},
	[22] = { ['x'] = 2029.6854248047, ['y'] = 4980.6967773438, ['z'] = 42.098358154297, ['grau'] = 238.48358154297},
	[23] = { ['x'] = 1673.1898193359, ['y'] = 4958.0278320313, ['z'] = 42.340553283691, ['grau'] = 220.65159606934},
	[24] = { ['x'] = 1927.5148925781, ['y'] = 4609.447265625, ['z'] = 40.360317230225, ['grau'] = 164.35575866699},
	[25] = { ['x'] = 2566.6513671875, ['y'] = 4273.947265625, ['z'] = 41.989032745361, ['grau'] = 234.26681518555},
}

Config.locsNorte3 = {
	[1] = { ['x'] = 1885.1818847656, ['y'] = 3775.1538085938, ['z'] = 32.786651611328, ['grau'] = 211.46054077148},
	[2] = { ['x'] = 2489.4052734375, ['y'] = 3758.6037597656, ['z'] = 42.253227233887, ['grau'] = 222.5584564209},
	[3] = { ['x'] = 2510.6062011719, ['y'] = 4214.8403320313, ['z'] = 39.931610107422, ['grau'] = 60.168956756592},
	[4] = { ['x'] = 2564.5805664063, ['y'] = 4680.2221679688, ['z'] = 34.077201843262, ['grau'] = 46.827743530273},
	[5] = { ['x'] = 1458.80078125, ['y'] = 6346.248046875, ['z'] = 23.9655418396, ['grau'] = 40.43196105957},
	[6] = { ['x'] = 281.95254516602, ['y'] = 6789.1884765625, ['z'] = 15.695026397705, ['grau'] = 265.57684326172},
	[7] = { ['x'] = -154.45634460449, ['y'] = 6433.8759765625, ['z'] = 31.915897369385, ['grau'] = 204.02239990234},
	[8] = { ['x'] = -668.07861328125, ['y'] = 5812.9116210938, ['z'] = 17.518283843994, ['grau'] = 333.10314941406},
	[9] = { ['x'] = -575.87243652344, ['y'] = 5350.1342773438, ['z'] = 70.214401245117, ['grau'] = 254.86386108398},
	[10] = { ['x'] = -78.033615112305, ['y'] = 6210.5009765625, ['z'] = 31.464805603027, ['grau'] = 235.74139404297},
	[11] = { ['x'] = 1363.9968261719, ['y'] = 6549.2104492188, ['z'] = 14.6075258255, ['grau'] = 358.22113037109},
	[12] = { ['x'] = 2899.4584960938, ['y'] = 4399.3095703125, ['z'] = 50.234760284424, ['grau'] = 217.951171875},
	[13] = { ['x'] = 2634.224609375, ['y'] = 3291.9655761719, ['z'] = 55.728363037109, ['grau'] = 150.47944641113},
	[14] = { ['x'] = 2527.482421875, ['y'] = 2586.283203125, ['z'] = 37.944873809814, ['grau'] = 261.73788452148},
	[15] = { ['x'] = 2357.1472167969, ['y'] = 2608.8107910156, ['z'] = 46.66764831543, ['grau'] = 150.01094055176},
	[16] = { ['x'] = 2368.0229492188, ['y'] = 3156.6044921875, ['z'] = 48.208744049072, ['grau'] = 38.564521789551},
	[17] = { ['x'] = 2175.7138671875, ['y'] = 3321.2316894531, ['z'] = 45.966487884521, ['grau'] = 211.78511047363},
	[18] = { ['x'] = 2271.03515625, ['y'] = 3756.8039550781, ['z'] = 38.424072265625, ['grau'] = 33.857475280762},
	[19] = { ['x'] = 2455.7419433594, ['y'] = 4058.13671875, ['z'] = 38.064720153809, ['grau'] = 245.45184326172},
	[20] = { ['x'] = 2639.6018066406, ['y'] = 4246.1416015625, ['z'] = 44.746807098389, ['grau'] = 36.106880187988},
	[21] = { ['x'] = 2879.8168945313, ['y'] = 4490.9155273438, ['z'] = 48.144878387451, ['grau'] = 159.1071472168},
	[22] = { ['x'] = 2029.6854248047, ['y'] = 4980.6967773438, ['z'] = 42.098358154297, ['grau'] = 238.48358154297},
	[23] = { ['x'] = 1673.1898193359, ['y'] = 4958.0278320313, ['z'] = 42.340553283691, ['grau'] = 220.65159606934},
	[24] = { ['x'] = 1927.5148925781, ['y'] = 4609.447265625, ['z'] = 40.360317230225, ['grau'] = 164.35575866699},
	[25] = { ['x'] = 2566.6513671875, ['y'] = 4273.947265625, ['z'] = 41.989032745361, ['grau'] = 234.26681518555},
}

-- Rotas extrar abaixo para usar caso queira


Config.drogas = {
	[1] = { ['x'] = 1395.2102050781, ['y'] = 3624.0947265625, ['z'] = 35.012115478516, ['grau'] = 23.905122756958}, 
	[2] = { ['x'] = 917.51202392578, ['y'] = 3655.4047851563, ['z'] = 32.484153747559, ['grau'] = 3.9428629875183}, 
	[3] = { ['x'] = 378.88537597656, ['y'] = 3583.6418457031, ['z'] = 33.292205810547, ['grau'] = 83.060432434082}, 
	[4] = { ['x'] = 182.83894348145, ['y'] = 2790.2570800781, ['z'] = 45.606254577637, ['grau'] = 7.4695911407471}, 
	[5] = { ['x'] = -310.35803222656, ['y'] = 2794.0422363281, ['z'] = 59.470573425293, ['grau'] = 144.3599395752}, 
	[6] = { ['x'] = -1100.7280273438, ['y'] = 2722.4853515625, ['z'] = 18.800415039063, ['grau'] = 41.775611877441}, 
	[7] = { ['x'] = -2520.8247070313, ['y'] = 2310.4528808594, ['z'] = 33.215839385986, ['grau'] = 266.21505737305}, 
	[8] = { ['x'] = -3182.3349609375, ['y'] = 1310.5224609375, ['z'] = 14.5599193573, ['grau'] = 334.94012451172}, 
	[9] = { ['x'] = -3109.3642578125, ['y'] = 751.67950439453, ['z'] = 24.701894760132, ['grau'] = 143.24948120117}, 
	[10] = { ['x'] = -3116.6359863281, ['y'] = 242.25866699219, ['z'] = 12.492219924927,['grau'] = 287.6985168457}, 
	[11] = { ['x'] = -2213.6765136719, ['y'] = -370.90585327148, ['z'] = 13.320321083069, ['grau'] = 39.664745330811}, 
	[12] = { ['x'] = -1531.0490722656, ['y'] = -886.41107177734, ['z'] = 10.17386341095, ['grau'] = 36.882663726807}, 
	[13] = { ['x'] = -1337.0124511719, ['y'] = -1161.7435302734, ['z'] = 4.5099244117737, ['grau'] = 258.72445678711}, 
	[14] = { ['x'] = -1160.9222412109, ['y'] = -1101.6248779297, ['z'] = 6.5313539505005, ['grau'] = 25.47193145752}, 
	[15] = { ['x'] = -1272.1724853516, ['y'] = -862.15209960938, ['z'] = 12.619379043579, ['grau'] = 32.590698242188}, 
	[16] = { ['x'] = -1368.2908935547, ['y'] = -647.3857421875, ['z'] = 28.694114685059, ['grau'] = 119.91717529297}, 
	[17] = { ['x'] = -833.39904785156, ['y'] = -1071.4526367188, ['z'] = 11.654335975647, ['grau'] = 27.197071075439}, 
	[18] = { ['x'] = -545.98120117188, ['y'] = -873.88299560547, ['z'] = 27.198791503906, ['grau'] = 178.59214782715}, 
	[19] = { ['x'] = 15.908989906311, ['y'] = -1032.4996337891, ['z'] = 29.415523529053, ['grau'] = 159.78851318359}, 
	[20] = { ['x'] = 56.500690460205, ['y'] = -1435.2534179688, ['z'] = 29.311725616455, ['grau'] = 49.837184906006}, 
	[21] = { ['x'] = 89.500282287598, ['y'] = -1745.2708740234, ['z'] = 30.087087631226, ['grau'] = 314.19177246094}, 
	[22] = { ['x'] = 507.59851074219, ['y'] = -1831.9495849609, ['z'] = 28.87096786499, ['grau'] = 231.8528137207}, 
	[23] = { ['x'] = 486.38250732422, ['y'] = -1295.9875488281, ['z'] = 29.57374382019, ['grau'] = 271.40121459961}, 
	[24] = { ['x'] = 494.15649414063, ['y'] = -570.88635253906, ['z'] = 24.54478263855, ['grau'] = 267.4208984375}, 
	[25] = { ['x'] = 402.07504272461, ['y'] = -339.28927612305, ['z'] = 46.973007202148, ['grau'] = 162.84762573242}, 
	[26] = { ['x'] = 1099.5961914063, ['y'] = -345.69451904297, ['z'] = 67.183303833008, ['grau'] = 300.45767211914}, 
	[27] = { ['x'] = 814.48913574219, ['y'] = -93.375915527344, ['z'] = 80.599090576172, ['grau'] = 330.53555297852}, 
	[28] = { ['x'] = 2618.4208984375, ['y'] = 3275.2741699219, ['z'] = 55.738212585449, ['grau'] = 239.05241394043}, 
	[29] = { ['x'] = 2881.7924804688, ['y'] = 4511.7294921875, ['z'] = 48.000877380371, ['grau'] = 76.290077209473}, 
	[30] = { ['x'] = 2567.1064453125, ['y'] = 4273.8481445313, ['z'] = 41.989082336426, ['grau'] = 241.36804199219}, 
	[31] = { ['x'] = 2160.2421875, ['y'] = 4789.5727539063, ['z'] = 41.960704803467, ['grau'] = 81.814956665039}, 
	[32] = { ['x'] = 1958.7974853516, ['y'] = 4628.0063476563, ['z'] = 41.066925048828, ['grau'] = 37.08321762085}, 
	[33] = { ['x'] = 1801.0025634766, ['y'] = 4616.2075195313, ['z'] = 37.223823547363, ['grau'] = 187.19781494141}, 
	[34] = { ['x'] = 1662.2658691406, ['y'] = 4776.1357421875, ['z'] = 42.007595062256, ['grau'] = 280.67532348633}, 
	[35] = { ['x'] = 1961.3879394531, ['y'] = 5185.046875, ['z'] = 47.966899871826, ['grau'] = 282.73754882813}, 
	[36] = { ['x'] = 2251.8552246094, ['y'] = 5155.2719726563, ['z'] = 57.887100219727, ['grau'] = 235.91421508789}, 
	[37] = { ['x'] = 2570.494140625, ['y'] = 4667.82421875, ['z'] = 34.07674407959, ['grau'] = 135.23368835449}, 
	[38] = { ['x'] = 2418.9421386719, ['y'] = 4020.4709472656, ['z'] = 36.83406829834, ['grau'] = 251.89302062988}, 
	[39] = { ['x'] = 1975.39453125, ['y'] = 3818.5671386719, ['z'] = 33.436347961426, ['grau'] = 56.783828735352}, 
	[40] = { ['x'] = 1916.2265625, ['y'] = 3909.1569824219, ['z'] = 33.441650390625, ['grau'] = 229.68148803711}, 
}

Config.mochila = {
	[1] = { ['x'] = 833.10217285156, ['y'] = -1208.5480957031, ['z'] = 25.820569992065, ['grau'] = 350.19927978516},
	[2] = { ['x'] = 988.02740478516, ['y'] = -1254.8468017578, ['z'] = 27.065780639648, ['grau'] = 298.78875732422},
	[3] = { ['x'] = 980.17846679688, ['y'] = -1396.6259765625, ['z'] = 31.685354232788, ['grau'] = 208.8250579834},
	[4] = { ['x'] = 915.15802001953, ['y'] = -1514.5411376953, ['z'] = 31.204767227173, ['grau'] = 175.72560119629},
	[5] = { ['x'] = 477.52694702148, ['y'] = -1397.443359375, ['z'] = 31.042016983032, ['grau'] = 268.23834228516},
	[6] = { ['x'] = 452.75518798828, ['y'] = -1305.6436767578, ['z'] = 30.12084197998, ['grau'] = 321.28814697266},
	[7] = { ['x'] = 366.27001953125, ['y'] = -1251.0185546875, ['z'] = 32.705455780029, ['grau'] = 323.51745605469},
	[8] = { ['x'] = 427.85247802734, ['y'] = -1515.2313232422, ['z'] = 29.289945602417, ['grau'] = 203.29539489746},
	[9] = { ['x'] = 500.98779296875, ['y'] = -1533.2738037109, ['z'] = 29.287698745728, ['grau'] = 235.40832519531},
	[10] = { ['x'] = 247.6082611084, ['y'] = -1361.4737548828, ['z'] = 30.551731109619, ['grau'] = 316.56021118164},
	[11] = { ['x'] = 132.9916229248, ['y'] = -1328.9284667969, ['z'] = 34.028335571289, ['grau'] = 304.48394775391},
	[12] = { ['x'] = 148.37461853027, ['y'] = -1113.4833984375, ['z'] = 29.304792404175, ['grau'] = 96.156097412109},
	[13] = { ['x'] = 328.24136352539, ['y'] = -940.16094970703, ['z'] = 29.406301498413, ['grau'] = 183.82356262207},
	[14] = { ['x'] = 387.08001708984, ['y'] = -773.4755859375, ['z'] = 29.291791915894, ['grau'] = 0.66637206077576},
	[15] = { ['x'] = 232.45317077637, ['y'] = -714.49633789063, ['z'] = 35.774940490723, ['grau'] = 65.517417907715},
	[16] = { ['x'] = 778.01812744141, ['y'] = -393.30032348633, ['z'] = 33.426853179932, ['grau'] = 105.43688201904},
	[17] = { ['x'] = 1099.27734375, ['y'] = -345.89083862305, ['z'] = 67.183372497559, ['grau'] = 302.95452880859},
	[18] = { ['x'] = 1159.7901611328, ['y'] = -776.67364501953, ['z'] = 57.598739624023, ['grau'] = 357.0739440918},
	[19] = { ['x'] = 1130.1754150391, ['y'] = -989.38293457031, ['z'] = 45.967193603516, ['grau'] = 100.27503967285},
	[20] = { ['x'] = 1192.6363525391, ['y'] = -1249.2199707031, ['z'] = 40.321533203125, ['grau'] = 356.54116821289},
	[21] = { ['x'] = 838.02508544922, ['y'] = -1375.4801025391, ['z'] = 26.311710357666, ['grau'] = 353.56295776367}
}
