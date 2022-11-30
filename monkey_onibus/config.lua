Config = {
    -- ["Start"] = {
    --     ["Coords"] = { 454.08462524414, -600.6884765625, 28.577842712402 }, -- CDS Para entrar em serviço.
    --     ["Distance"] = 30, -- Distancia Para entrar em serviço.
    -- },
    -- ["Payment"] = { 1600,2000 }, -- Pagamento por NPC (Minimo,Maximo)
    ["Notify"] = {
        ["Enter"] = "Você entrou em serviço.", -- Notify entrou em serviço.
        ["Leave"] = "Você saiu de serviço." -- Notify saiu em serviço.
    },
    ["Locs_aventura"] = {
        ["Payment"] = { 20000,30000 },
        ['car'] = "mesa",
        ['init'] = {
            [1] = {
                ["Coords"] = { -1485.9057617188, -663.99188232422, 28.943204879761 }, -- CDS aonde o carro terá que parar.
                ["CoordsPed"] = { -1477.1069335938, -674.49249267578, 29.041667938232 }, -- CDS aonde o NPC será criado.
            },
            [2] = {
                ["Coords"] = { -1285.1204833984, -428.56774902344, 34.770706176758 }, -- CDS aonde o carro terá que parar.
                ["CoordsPed"] = { -1288.3093261719, -430.29284667969, 35.15705871582 }, -- CDS aonde o NPC será criado.
            },
            [3] = {
                ["Coords"] = { -1096.1474609375, -315.29586791992, 37.659534454346 }, -- CDS aonde o carro terá que parar.
                ["CoordsPed"] = { -1095.3314208984, -325.60952758789, 37.823623657227 }, -- CDS aonde o NPC será criado.
            }
        },
        ['trilha'] = {
            [1] = {
                ["Coords"] = { -388.87469482422, 1198.4699707031, 325.64138793945 }, -- CDS aonde o carro terá que parar.
            },
            [2] = {
                ["Coords"] = { -452.33700561523, 1595.7087402344, 359.07684326172 }, -- CDS aonde o carro terá que parar.
            },
            [3] = {
                ["Coords"] = { 1919.7391357422, 578.50201416016, 175.52285766602 }, -- CDS aonde o carro terá que parar.
            },
            [4] = {
                ["Coords"] = { 1776.2946777344, 4589.3369140625, 37.709648132324 }, -- CDS aonde o carro terá que parar.
            },
            [5] = {
                ["Coords"] = { -1150.7967529297, 4922.7646484375, 221.33200073242 }, -- CDS aonde o carro terá que parar.
            },
            [6] = {
                ["Coords"] = { 3331.0048828125, 5155.5747070313, 18.309141159058 }, -- CDS aonde o carro terá que parar.
            }
        }

    },
    ["Locs_viagem"] = {
        ["Payment"] = { 10000,15000 },
        ['car'] = "youga",
        ['init'] = {
            [1] = {
                ["Coords"] = { 461.62890625, -620.53295898438, 28.499755859375 }, -- CDS aonde o carro terá que parar.
                ["CoordsPed"] = { 451.93463134766, -622.03338623047, 28.55958366394 }, -- CDS aonde o NPC será criado.
            }
        },
        ['trilha'] = {
            [1] = {
                ["Coords"] = { 1956.6306152344, 3843.6669921875, 32.010334014893 }, -- CDS aonde o carro terá que parar.
            },
            [2] = {
                ["Coords"] = { 181.32723999023, 6572.3251953125, 31.844921112061 }, -- CDS aonde o carro terá que parar.
            },
            [3] = {
                ["Coords"] = { -773.36328125, 5532.240234375, 33.479663848877 }, -- CDS aonde o carro terá que parar.
            },
            [4] = {
                ["Coords"] = { -3026.2189941406, 108.80663299561, 11.625774383545 }, -- CDS aonde o carro terá que parar.
            },
            [5] = {
                ["Coords"] = { -1455.1149902344, -960.94757080078, 7.3371834754944 }, -- CDS aonde o carro terá que parar.
            }
        }

    },

    ["Locs_turismo"] = {
        ["Payment"] = { 5000,10000 },
        ['car'] = "dubsta",
        ['init'] = {
            [1] = {
                ["Coords"] = { -1018.5935668945, -2731.396484375, 13.692849159241 }, -- CDS aonde o carro terá que parar.
                ["CoordsPed"] = { -1025.0549316406, -2740.3913574219, 13.756649971008 }, -- CDS aonde o NPC será criado.
            }
        },
        ['trilha'] = {
            [1] = {
                ["Coords"] = { -1050.1457519531, -1670.9796142578, 4.3347053527832 }, -- CDS aonde o carro terá que parar.
            },
            [2] = {
                ["Coords"] = { -1170.5389404297, -1768.435546875, 3.8683040142059 }, -- CDS aonde o carro terá que parar.
            },
            [3] = {
                ["Coords"] = { -1127.5356445313, -1647.8756103516, 4.3368215560913 }, -- CDS aonde o carro terá que parar.
            },
            [4] = {
                ["Coords"] = { -1194.8555908203, -1551.2576904297, 4.3536291122437 }, -- CDS aonde o carro terá que parar.
            },
            [5] = {
                ["Coords"] = { -1323.0126953125, -1324.8333740234, 4.7486262321472 }, -- CDS aonde o carro terá que parar.
            },
            [6] = {
                ["Coords"] = { -1479.5224609375, -961.68505859375, 7.5325894355774 }, -- CDS aonde o carro terá que parar.
            },
            [7] = {
                ["Coords"] = { -1651.2763671875, -952.63171386719, 7.7413158416748 }, -- CDS aonde o carro terá que parar.
            },
            [8] = {
                ["Coords"] = { -1440.2136230469, -954.13348388672, 7.771698474884 }, -- CDS aonde o carro terá que parar.
            },
            [9] = {
                ["Coords"] = { -1616.5994873047, -957.79010009766, 13.017602920532 }, -- CDS aonde o carro terá que parar.
            },
            [10] = {
                ["Coords"] = { -1606.0754394531, -1030.5333251953, 13.081232070923 }, -- CDS aonde o carro terá que parar.
            }
        }

    },
    ["Locs_onibus"] = {
        ["Payment"] = { 1600,2000 },
        [1] = {
            ["Coords"] = { 308.27484130859, -766.13305664063, 29.286647796631 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 299.08248901367, -759.42071533203, 29.354455947876 }, -- CDS aonde o NPC será criado.
        },
        [2] = {
            ["Coords"] = { 114.49124908447, -785.46484375, 31.371356964111}, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 114.28382110596, -780.93646240234, 31.408542633057}, -- CDS aonde o NPC será criado.
        },
        [3] = {
            ["Coords"] = { -171.43190002441, -819.39367675781, 31.144906997681 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -176.11799621582, -818.45178222656, 31.123083114624 }, -- CDS aonde o NPC será criado.
        },
        [4] = {
            ["Coords"] = { -271.9944152832, -823.79559326172, 31.757389068604 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -267.95162963867, -824.45513916016, 31.832782745361 }, -- CDS aonde o NPC será criado.
        },
        [5] = {
            ["Coords"] = { -523.95190429688, -267.7038269043, 35.298557281494 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -524.78363037109, -263.73178100586, 35.459358215332 }, -- CDS aonde o NPC será criado.
        },
        [6] = {
            ["Coords"] = { -931.50640869141, -126.66586303711, 37.581176757813 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -932.32183837891, -120.37620544434, 37.777797698975 }, -- CDS aonde o NPC será criado.
        },
        [7] = {
            ["Coords"] = { -678.58355712891, -376.18405151367, 34.259376525879 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -682.33032226563, -380.17562866211, 34.240776062012 }, -- CDS aonde o NPC será criado.
        },
        [8] = {
            ["Coords"] = { -505.66748046875, -667.40539550781, 33.028633117676 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -505.09912109375, -670.55548095703, 33.098350524902 }, -- CDS aonde o NPC será criado.
        },
        [9] = {
            ["Coords"] = { -244.54586791992, -714.18670654297, 33.437160491943 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -247.76425170898, -713.15393066406, 33.54927444458 }, -- CDS aonde o NPC será criado.
        },
        [10] = {
            ["Coords"] = { -250.48759460449, -882.57965087891, 30.616250991821 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -250.06735229492, -887.01770019531, 30.620477676392 }, -- CDS aonde o NPC será criado.
        },
        [11] = {
            ["Coords"] = { 355.53240966797, -1064.0903320313, 29.394721984863 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 355.82928466797, -1067.1978759766, 29.565805435181 }, -- CDS aonde o NPC será criado.
        }
    },
    ["Locs_taxi"] = {
        ["Payment"] = {1600, 2000},
        [1] = {
            ["Coords"] = { 151.30,-1028.63,28.84 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 152.45,-1041.24,29.37 }, -- CDS aonde o NPC será criado.
        },
        [2] = {
            ["Coords"] = { 423.84,-959.30,28.81 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 437.37,-979.03,30.68 }, -- CDS aonde o NPC será criado.
        },
        [3] = {
            ["Coords"] = { 1.03,-1510.86,29.40 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 20.67,-1505.62,31.85 }, -- CDS aonde o NPC será criado.
        },
        [4] = {
            ["Coords"] = { -188.07,-1612.28,33.39 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -189.55,-1585.80,34.76 }, -- CDS aonde o NPC será criado.
        },
        [5] = {
            ["Coords"] = { 98.88,-1927.16,20.25 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 101.02,-1912.35,21.40 }, -- CDS aonde o NPC será criado.
        },
        [6] = {
            ["Coords"] = { 320.98,-2022.02,20.40 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 335.73,-2010.77,22.31 }, -- CDS aonde o NPC será criado.
        },
        [7] = {
            ["Coords"] = { 755.53,-2486.26,19.54 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 774.34,-2475.07,20.14 }, -- CDS aonde o NPC será criado.
        },
        [8] = {
            ["Coords"] = { 1057.66,-2124.80,32.20 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 1040.09,-2115.65,32.84 }, -- CDS aonde o NPC será criado.
        },
        [9] = {
            ["Coords"] = { 1377.08,-1530.01,56.07 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 1379.33,-1514.99,58.43 }, -- CDS aonde o NPC será criado.
        },
        [10] = {
            ["Coords"] = { 1260.24,-588.15,68.53 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 1240.60,-601.63,69.78 }, -- CDS aonde o NPC será criado.
        },
        [11] = {
            ["Coords"] = { 899.58,-590.58,56.85 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 886.76,-608.20,58.44 }, -- CDS aonde o NPC será criado.
        },
        [12] = {
            ["Coords"] = { 945.18,-140.04,74.07 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 959.34,-121.23,74.96 }, -- CDS aonde o NPC será criado.
        },
        [13] = {
            ["Coords"] = { 84.44,476.19,146.91 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 80.10,486.12,148.20 }, -- CDS aonde o NPC será criado.
        },
        [14] = {
            ["Coords"] = { -720.03,482.23,107.10 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -721.10,489.75,109.38 }, -- CDS aonde o NPC será criado.
        },
        [15] = {
            ["Coords"] = { -1244.39,497.98,93.86 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1229.15,515.72,95.42 }, -- CDS aonde o NPC será criado.
        },
        [16] = {
            ["Coords"] = { -1514.99,442.97,109.70 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1495.97,437.10,112.49 }, -- CDS aonde o NPC será criado.
        },
        [17] = {
            ["Coords"] = { -1684.14,-308.47,51.41 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1684.87,-291.66,51.89 }, -- CDS aonde o NPC será criado.
        },
        [18] = {
            ["Coords"] = { -1413.14,-531.91,30.98 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1447.29,-537.71,34.74 }, -- CDS aonde o NPC será criado.
        },
        [19] = {
            ["Coords"] = { -1036.80,-492.27,36.15 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1007.32,-486.80,39.97 }, -- CDS aonde o NPC será criado.
        },
        [20] = {
            ["Coords"] = { -551.46,-648.64,32.73 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -533.39,-622.87,34.67 }, -- CDS aonde o NPC será criado.
        },
        [21] = {
            ["Coords"] = { -616.30,-920.80,22.98 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -598.49,-929.96,23.86 }, -- CDS aonde o NPC será criado.
        },
        [22] = {
            ["Coords"] = { -752.13,-1041.29,12.25 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -759.21,-1047.16,13.50 }, -- CDS aonde o NPC será criado.
        },
        [23] = {
            ["Coords"] = { -1155.20,-1413.48,4.46 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -1150.56,-1426.38,4.95 }, -- CDS aonde o NPC será criado.
        },
        [24] = {
            ["Coords"] = { -997.88,-1599.65,4.59 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -989.04,-1575.82,5.17 }, -- CDS aonde o NPC será criado.
        },
        [25] = {
            ["Coords"] = { -829.38,-1218.09,6.54 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -822.50,-1223.35,7.36 }, -- CDS aonde o NPC será criado.
        },
        [26] = {
            ["Coords"] = { -334.47,-1418.13,29.71 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -320.10,-1389.73,36.50 }, -- CDS aonde o NPC será criado.
        },
        [27] = {
            ["Coords"] = { 135.28,-1306.46,28.65 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { 132.91,-1293.90,29.26 }, -- CDS aonde o NPC será criado.
        },
        [28] = {
            ["Coords"] = { -34.00,-1079.86,26.26 }, -- CDS aonde o carro terá que parar.
            ["CoordsPed"] = { -39.02,-1082.46,26.42 }, -- CDS aonde o NPC será criado.
        }
    },
    ["PedList"] = {
        [1] = {
            ["Model"] = "ig_abigail", -- Nome do NPC
            ["Hash"] = 0x400AEC41 -- Hash do NPC
        },
        [2] = {
            ["Model"] = "a_m_o_acult_02", -- Nome do NPC 
            ["Hash"] = 0x4BA14CCA -- Hash do NPC
        },
        [3] = {
            ["Model"] = "a_m_m_afriamer_01", -- Nome do NPC
            ["Hash"] = 0xD172497E -- Hash do NPC
        },
        [4] = {
            ["Model"] = "ig_mp_agent14", -- Nome do NPC
            ["Hash"] = 0xFBF98469 -- Hash do NPC
        },
        [5] = {
            ["Model"] = "u_m_m_aldinapoli", -- Nome do NPC
            ["Hash"] = 0xF0EC56E2 -- Hash do NPC
        },
        [6] = {
            ["Model"] = "ig_amandatownley", -- Nome do NPC
            ["Hash"] = 0x6D1E15F7 -- Hash do NPC
        },
        [7] = {
            ["Model"] = "ig_andreas", -- Nome do NPC
            ["Hash"] = 0x47E4EEA0 -- Hash do NPC
        },
        [8] = {
            ["Model"] = "csb_anita", -- Nome do NPC
            ["Hash"] = 0x0703F106 -- Hash do NPC
        },
        [9] = {
            ["Model"] = "u_m_y_antonb", -- Nome do NPC
            ["Hash"] = 0xCF623A2C -- Hash do NPC
        },
        [10] = {
            ["Model"] = "g_m_y_armgoon_02", -- Nome do NPC
            ["Hash"] = 0xC54E878A -- Hash do NPC
        },
        [11] = {
            ["Model"] = "ig_ashley", -- Nome do NPC
            ["Hash"] = 0x7EF440DB -- Hash do NPC
        },
        [12] = {
            ["Model"] = "s_m_m_autoshop_01", -- Nome do NPC
            ["Hash"] = 0x040EABE3 -- Hash do NPC
        },
        [13] = {
            ["Model"] = "g_m_y_ballaeast_01",-- Nome do NPC
            ["Hash"] = 0xF42EE883 -- Hash do NPC
        },
        [14] = {
            ["Model"] = "g_m_y_ballaorig_01", -- Nome do NPC
            ["Hash"] = 0x231AF63F -- Hash do NPC
        },
        [15] = {
            ["Model"] = "s_m_y_barman_01", -- Nome do NPC
            ["Hash"] = 0xE5A11106 -- Hash do NPC
        },
        [16] = {
            ["Model"] = "u_m_y_baygor", -- Nome do NPC
            ["Hash"] = 0x5244247D -- Hash do NPC
        },
        [17] = {
            ["Model"] = "a_m_o_beach_01", -- Nome do NPC
            ["Hash"] = 0x8427D398 -- Hash do NPC
        },
        [18] = {
            ["Model"] = "a_m_y_beachvesp_01", -- Nome do NPC
            ["Hash"] = 0x7E0961B8 -- Hash do NPC
        },
        [19] = {
            ["Model"] = "ig_bestmen",-- Nome do NPC
            ["Hash"] = 0x5746CD96 -- Hash do NPC
        },
        [20] = {
            ["Model"] = "a_f_y_bevhills_01", -- Nome do NPC
            ["Hash"] = 0x445AC854 -- Hash do NPC
        }
    }
}

Config.usar_monkey_marker = false
--- caso queria colocar os marker manualmente pelo monkey marker colocar true, essa opção desliga todos marker desse modulo