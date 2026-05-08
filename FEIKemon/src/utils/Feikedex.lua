-- =============================================================
-- FEIKEDEX - Banco de dados dos FeiKémons
-- =============================================================

local feikedex = {

    -- ---------------------------------------------------------
    -- TIPOS
    -- Cada feikemon e cada ataque referencia um ou dois tipos
    -- ---------------------------------------------------------
    tipos = {
        Software = { cor = {0.2, 0.6, 1.0} },  -- azul
        Hardware = { cor = {0.7, 0.7, 0.7} },  -- cinza
        Rede     = { cor = {0.2, 0.9, 0.5} },  -- verde
        Energia  = { cor = {1.0, 0.8, 0.0} },  -- amarelo
    },

    -- ---------------------------------------------------------
    -- ATAQUES
    -- campos:
    --   dano  : dano base do ataque
    --   tipo  : lista com 1 ou 2 tipos (referencia feikedex.tipos)
    -- ---------------------------------------------------------
    ataques = {

        -- [ SOFTWARE ]
        ["Compilar"]           = { dano = 20,  tipo = {"Software"} },
        ["Bug Critico"]        = { dano = 35,  tipo = {"Software"} },
        ["Stack Overflow"]     = { dano = 50,  tipo = {"Software"} },
        ["Segmentation Fault"] = { dano = 65,  tipo = {"Software", "Hardware"} },
        ["Deploy em Producao"] = { dano = 80,  tipo = {"Software", "Rede"} },
        ["Kernel Panic"]       = { dano = 100, tipo = {"Software", "Hardware"} },

        -- [ HARDWARE ]
        ["Clique Duplo"]       = { dano = 20,  tipo = {"Hardware"} },
        ["Curto Circuito"]     = { dano = 40,  tipo = {"Hardware"} },
        ["Overclocking"]       = { dano = 65,  tipo = {"Hardware", "Energia"} },
        ["Tela Azul"]          = { dano = 55,  tipo = {"Hardware", "Software"} },

        -- [ REDE ]
        ["Ping Flood"]         = { dano = 35,  tipo = {"Rede"} },
        ["Pacote Perdido"]     = { dano = 30,  tipo = {"Rede"} },
        ["Latencia Alta"]      = { dano = 45,  tipo = {"Rede"} },
        ["DDoS"]               = { dano = 75,  tipo = {"Rede", "Software"} },
        ["Efeito Cascata"]     = { dano = 60,  tipo = {"Rede", "Energia"} },

        -- [ ENERGIA ]
        ["Rush de Cafeina"]    = { dano = 25,  tipo = {"Energia"} },
        ["Tremor Nervoso"]     = { dano = 40,  tipo = {"Energia"} },
        ["Zero Caloria"]       = { dano = 45,  tipo = {"Energia"} },
        ["Overdose Energetica"]= { dano = 70,  tipo = {"Energia"} },
        ["Pico de Adrenalina"] = { dano = 95,  tipo = {"Energia"} },
        ["Molho Especial"]     = { dano = 20,  tipo = {"Energia"} },
        ["Empanado Crocante"]  = { dano = 50,  tipo = {"Energia"} },
        ["Indigestao"]         = { dano = 80,  tipo = {"Energia"} },
    },

    -- ---------------------------------------------------------
    -- FEIKEMONS
    -- campos:
    --   nome        : nome do feikemon
    --   tipo        : lista com 1 ou 2 tipos (referencia feikedex.tipos)
    --   foto_frente : caminho relativo ao main.lua
    --   foto_verso  : caminho relativo ao main.lua
    --   hp_max      : pontos de vida maximos
    --   hp_atual    : pontos de vida atuais (inicializado igual ao hp_max)
    --   ataques     : lista de { nome, level } — level minimo para aprender o ataque
    -- ---------------------------------------------------------
    feikemons = {

        -- 01 - LINUX
        {
            nome        = "Linux",
            tipo        = {"Software", "Hardware"},
            foto_frente = "assets/PixelArtsFeiKemon/LinuxFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/LinuxCostas.png",
            hp_max      = 120,
            hp_atual    = 120,
            ataques = {
                "Compilar",
                "Kernel Panic",
                "Segmentation Fault",
                "Deploy em Producao",
            }
        },

        -- 02 - WINDOWS
        {
            nome        = "Windows",
            tipo        = {"Software"},
            foto_frente = "assets/PixelArtsFeiKemon/WindowsFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/WindowsCostas.png",
            hp_max      = 110,
            hp_atual    = 110,
            ataques = {
                "Compilar",
                "Tela Azul",
                "Bug Critico",
                "Stack Overflow",
            }
        },

        -- 03 - JAVA
        {
            nome        = "Java",
            tipo        = {"Software"},
            foto_frente = "assets/PixelArtsFeiKemon/JavaFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/JavaCostas.png",
            hp_max      = 100,
            hp_atual    = 100,
            ataques = {
                "Compilar",
                "Bug Critico",
                "Stack Overflow",
                "Deploy em Producao",
            }
        },

        -- 04 - PYTHON
        {
            nome        = "Python",
            tipo        = {"Software"},
            foto_frente = "assets/PixelArtsFeiKemon/PythonFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/PythonCostas.png",
            hp_max      = 95,
            hp_atual    = 95,
            ataques = {
                "Compilar",
                "Stack Overflow",
                "Bug Critico",
                "Kernel Panic",
            }
        },

        -- 05 - C
        {
            nome        = "C",
            tipo        = {"Software", "Hardware"},
            foto_frente = "assets/PixelArtsFeiKemon/CFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/CCostas.png",
            hp_max      = 90,
            hp_atual    = 90,
            ataques = {
                "Compilar",
                "Segmentation Fault",
                "Stack Overflow",
                "Kernel Panic",
            }
        },

        -- 06 - IPHONE
        {
            nome        = "Iphone",
            tipo        = {"Hardware", "Rede"},
            foto_frente = "assets/PixelArtsFeiKemon/IphoneFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/IphoneCostas.png",
            hp_max      = 105,
            hp_atual    = 105,
            ataques = {
                "Clique Duplo",
                "Ping Flood",
                "Latencia Alta",
                "DDoS",
            }
        },

        -- 07 - VR
        {
            nome        = "VR",
            tipo        = {"Hardware", "Software"},
            foto_frente = "assets/PixelArtsFeiKemon/VRFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/VRCostas.png",
            hp_max      = 100,
            hp_atual    = 100,
            ataques = {
                "Clique Duplo",
                "Compilar",
                "Overclocking",
                "Tela Azul",
            }
        },

        -- 08 - TECLADO
        {
            nome        = "Teclado",
            tipo        = {"Hardware"},
            foto_frente = "assets/PixelArtsFeiKemon/TecladoFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/TecladoCostas.png",
            hp_max      = 85,
            hp_atual    = 85,
            ataques = {
                "Clique Duplo",
                "Curto Circuito",
                "Tela Azul",
            }
        },

        -- 09 - MOUSE
        {
            nome        = "Mouse",
            tipo        = {"Hardware"},
            foto_frente = "assets/PixelArtsFeiKemon/MouseFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/MouseCostas.png",
            hp_max      = 80,
            hp_atual    = 80,
            ataques = {
                "Clique Duplo",
                "Curto Circuito",
                "Overclocking",
            }
        },

        -- 10 - MONITOR
        {
            nome        = "Monitor",
            tipo        = {"Hardware", "Software"},
            foto_frente = "assets/PixelArtsFeiKemon/MonitorFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/MonitorCostas.png",
            hp_max      = 95,
            hp_atual    = 95,
            ataques = {
                "Clique Duplo",
                "Bug Critico",
                "Tela Azul",
                "Deploy em Producao",
            }
        },

        -- 11 - MONSTER
        {
            nome        = "Monster",
            tipo        = {"Energia"},
            foto_frente = "assets/PixelArtsFeiKemon/MonsterFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/MonsterCostas.png",
            hp_max      = 110,
            hp_atual    = 110,
            ataques = {
                "Rush de Cafeina",
                "Tremor Nervoso",
                "Overdose Energetica",
                "Pico de Adrenalina",
            }
        },

        -- 12 - MONSTER ZERO
        {
            nome        = "MonsterZero",
            tipo        = {"Energia"},
            foto_frente = "assets/PixelArtsFeiKemon/MonsterZeroFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/MonsterZeroCostas.png",
            hp_max      = 100,
            hp_atual    = 100,
            ataques = {
                "Zero Caloria",
                "Rush de Cafeina",
                "Efeito Cascata",
                "Overdose Energetica",
            }
        },

        -- 13 - REDBULL
        {
            nome        = "Redbull",
            tipo        = {"Energia"},
            foto_frente = "assets/PixelArtsFeiKemon/RedbullFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/RedbullCostas.png",
            hp_max      = 115,
            hp_atual    = 115,
            ataques = {
                "Rush de Cafeina",
                "Tremor Nervoso",
                "Efeito Cascata",
                "Pico de Adrenalina",
            }
        },

        -- 14 - REDBULL ZERO
        {
            nome        = "RedbullZero",
            tipo        = {"Energia"},
            foto_frente = "assets/PixelArtsFeiKemon/RedbullZeroFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/RedbullZeroCostas.png",
            hp_max      = 105,
            hp_atual    = 105,
            ataques = {
                "Zero Caloria",
                "Rush de Cafeina",
                "Tremor Nervoso",
                "Efeito Cascata",
            }
        },

        -- 15 - PARMEGIANA
        {
            nome        = "Parmegiana",
            tipo        = {"Energia"},
            foto_frente = "assets/PixelArtsFeiKemon/ParmegianaFrente.png",
            foto_verso  = "assets/PixelArtsFeiKemon/ParmegianaCostas.png",
            hp_max      = 130,
            hp_atual    = 130,
            ataques = {
                "Molho Especial",
                "Empanado Crocante",
                "Indigestao",
                "Pico de Adrenalina",
            }
        },
    }
}

return feikedex
