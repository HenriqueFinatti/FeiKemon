local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'
local Trainer = require 'src/entities/Trainer'
local BattleManager = require 'src/managers/BattleManager'

local IgrejaFEI = Class {}

function IgrejaFEI:_criarTreinadoresMestres()
    local function montarTime(ids, level)
        level = level or 1
        local time = {}
        for _, id in ipairs(ids) do
            table.insert(time, BattleManager.montaFeiKemon(id, level))
        end
        return time
    end

    return {
        Trainer {
            nome = "Reitoria",
            x = 24, y = 23,
            ordem = 1,
            spritePath = 'assets/characters/Danilo.png',
            retratoPath = 'assets/professores/DaniloPerfil.png',
            time = montarTime({12, 13, 6, 11}, 12),
            timeIds = {12, 13, 6, 11},
            timeLevel = 12,
            falasPre = {
                {nome="Reitoria", texto="Sou a voz da FEI. Voce ousa desafiar a instituicao?"},
                {nome="Reitoria", texto="Mostre-me se voce realmente merece estar aqui!"},
            },
            falasPos = {
                {nome="Reitoria", texto="Impressionante... a FEI confia em voce agora."},
            }
        },
        Trainer {
            nome = "Padre",
            x = 24, y = -23,
            ordem = 2,
            spritePath = 'assets/characters/Padre.png',
            retratoPath = 'assets/professores/FagnerPerfil.png',
            time = montarTime({1, 5, 7, 10}, 15),
            timeIds = {1, 5, 7, 10},
            timeLevel = 15,
            falasPre = {
                {nome="Padre", texto="A FEI nasceu de fe e conhecimento. Prepare sua alma."},
                {nome="Padre", texto="Que a luz dos FeiKemons o guie... ou o consuma."},
            },
            falasPos = {
                {nome="Padre", texto="A fe nunca foi tao forte. Va em frente, jovem."},
            }
        },
        Trainer {
            nome = "Samir",
            x = 25, y = 70,
            ordem = 3,
            spritePath = 'assets/characters/Samir.png',
            retratoPath = 'assets/professores/SamirPerfil.png',
            time = montarTime({15, 14, 9, 4}, 18),
            timeIds = {15, 14, 9, 4},
            timeLevel = 18,
            falasPre = {
                {nome="Samir", texto="Matematica e a lingua do universo. E eu sou fluente."},
                {nome="Samir", texto="Vamos ver se seus calculos estao certos!"},
            },
            falasPos = {
                {nome="Samir", texto="Inacreditavel... voce resolveu a equacao da vitoria."},
            }
        },
        Trainer {
            nome = "Maua",
            x = 18, y = -216,
            ordem = 4,
            -- spritePath = 'assets/characters/Maua.png',
            spritePath = 'assets/characters/Fagner.png',
            retratoPath = 'assets/professores/DaniloPerfil.png',
            time = montarTime({15, 13, 11, 12}, 20),
            timeIds = {15, 13, 11, 12},
            timeLevel = 20,
            falasPre = {
                {nome="Maua", texto="Finalmente chegou. Sou o verdadeiro mestre por tras de tudo."},
                {nome="Maua", texto="A FEI sera minha! E voce nao pode me impedir!"},
            },
            falasPos = {
                {nome="Maua", texto="Nao... como pode?! A FEI... esta salva..."},
            }
        },
    }
end

function IgrejaFEI:_criarPorteiro()
    return {
        Trainer {
            nome = "Porteiro",
            x = 0, y = 100,
            ordem = 1,
            isNpc = true,
            spritePath = 'assets/characters/Fagner.png',
            retratoPath = 'assets/professores/FagnerPerfil.png',
            time = {},
            falasPre = {
                {nome="Porteiro", texto="A igreja esta fechada."},
                {nome="Porteiro", texto="Apenas quem derrotou a chefe de departamento pode entrar aqui."},
            },
            falasPos = {
                {nome="Porteiro", texto="Volte quando estiver pronto."},
            },
            onComplete = function()
                local MapManager = require 'src/managers/MapManager'
                local porta = {
                    destino = "area externa",
                    x = -40,
                    y = -171,
                }
                MapManager.mudarMapa(porta, Gameplay)
            end
        },
    }
end

function IgrejaFEI:init()
    self.map = sti('assets/maps/igreja/igreja_fei.lua')
    self.name = "igreja"
    self._estadoLeila = nil -- nil forca criacao na primeira atualizacao
    self:_atualizarTreinadores()
end

function IgrejaFEI:_atualizarTreinadores()
    local leilaDerrotada = Gameplay and Gameplay.leilaDerrotada
    if leilaDerrotada == self._estadoLeila then return end

    self._estadoLeila = leilaDerrotada

    if leilaDerrotada then
        self.trainers = self:_criarTreinadoresMestres()
    else
        self.trainers = self:_criarPorteiro()
    end

    -- Aplica estado salvo dos treinadores se houver
    local SaveManager = require 'src/managers/SaveManager'
    SaveManager.aplicarEstadoTreinadores(self)
end

function IgrejaFEI:setColliders()
    self.colliders = {}

    if self.map.layers["Colisao"] then
        for i, obj in pairs(self.map.layers["Colisao"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                collider:setType('static')
                collider:setCollisionClass('Obstaculo')
                table.insert(self.colliders, collider)
            end
        end
    end

    if self.map.layers["Portas"] then
        for i, obj in pairs(self.map.layers["Portas"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local item = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                item:setType('static')
                item:setCollisionClass('Portas')
                item:setObject(obj)
                item.destino = obj.properties["destino"]
                item.x = obj.properties["x"]
                item.y = obj.properties["y"]
                table.insert(self.colliders, item)
            end
        end
    end
end

function IgrejaFEI:update(dt)
    self:_atualizarTreinadores()

    if self.trainers then
        for _, trainer in ipairs(self.trainers) do
            trainer:update(dt)
        end
    end
end

function IgrejaFEI:draw()
    if self.map.layers["Piso"] then
        self.map:drawLayer(self.map.layers["Piso"])
    end
    if self.map.layers["Parede"] then
        self.map:drawLayer(self.map.layers["Parede"])
    end
    if self.map.layers["Banco"] then
        self.map:drawLayer(self.map.layers["Banco"])
    end
    if self.map.layers["Itens_Igreja"] then
        self.map:drawLayer(self.map.layers["Itens_Igreja"])
    end
    if self.trainers then
        for _, trainer in ipairs(self.trainers) do
            trainer:draw()
        end
    end
end

function IgrejaFEI:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

return IgrejaFEI
