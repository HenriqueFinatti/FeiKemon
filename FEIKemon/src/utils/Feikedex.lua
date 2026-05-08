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
                { nome = "Compilar",           level = 1  },
                { nome = "Kernel Panic",       level = 10 },
                { nome = "Segmentation Fault", level = 20 },
                { nome = "Deploy em Producao", level = 30 },
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
                { nome = "Compilar",       level = 1  },
                { nome = "Tela Azul",      level = 5  },
                { nome = "Bug Critico",    level = 10 },
                { nome = "Stack Overflow", level = 20 },
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
                { nome = "Compilar",           level = 1  },
                { nome = "Bug Critico",        level = 5  },
                { nome = "Stack Overflow",     level = 10 },
                { nome = "Deploy em Producao", level = 20 },
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
                { nome = "Compilar",       level = 1  },
                { nome = "Stack Overflow", level = 5  },
                { nome = "Bug Critico",    level = 10 },
                { nome = "Kernel Panic",   level = 25 },
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
                { nome = "Compilar",           level = 1  },
                { nome = "Segmentation Fault", level = 5  },
                { nome = "Stack Overflow",     level = 10 },
                { nome = "Kernel Panic",       level = 20 },
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
                { nome = "Clique Duplo",  level = 1  },
                { nome = "Ping Flood",    level = 5  },
                { nome = "Latencia Alta", level = 10 },
                { nome = "DDoS",          level = 25 },
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
                { nome = "Clique Duplo", level = 1  },
                { nome = "Compilar",     level = 5  },
                { nome = "Overclocking", level = 10 },
                { nome = "Tela Azul",    level = 20 },
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
                { nome = "Clique Duplo",  level = 1  },
                { nome = "Curto Circuito",level = 5  },
                { nome = "Tela Azul",     level = 15 },
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
                { nome = "Clique Duplo",  level = 1  },
                { nome = "Curto Circuito",level = 5  },
                { nome = "Overclocking",  level = 15 },
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
                { nome = "Clique Duplo",       level = 1  },
                { nome = "Bug Critico",        level = 5  },
                { nome = "Tela Azul",          level = 10 },
                { nome = "Deploy em Producao", level = 20 },
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
                { nome = "Rush de Cafeina",     level = 1  },
                { nome = "Tremor Nervoso",      level = 5  },
                { nome = "Overdose Energetica", level = 15 },
                { nome = "Pico de Adrenalina",  level = 25 },
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
                { nome = "Zero Caloria",        level = 1  },
                { nome = "Rush de Cafeina",     level = 5  },
                { nome = "Efeito Cascata",      level = 15 },
                { nome = "Overdose Energetica", level = 25 },
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
                { nome = "Rush de Cafeina",    level = 1  },
                { nome = "Tremor Nervoso",     level = 5  },
                { nome = "Efeito Cascata",     level = 10 },
                { nome = "Pico de Adrenalina", level = 20 },
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
                { nome = "Zero Caloria",       level = 1  },
                { nome = "Rush de Cafeina",    level = 5  },
                { nome = "Tremor Nervoso",     level = 10 },
                { nome = "Efeito Cascata",     level = 20 },
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
                { nome = "Molho Especial",     level = 1  },
                { nome = "Empanado Crocante",  level = 5  },
                { nome = "Indigestao",         level = 15 },
                { nome = "Pico de Adrenalina", level = 25 },
            }
        },
    }
}

return feikedex
