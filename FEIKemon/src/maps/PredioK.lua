local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'
local Trainer = require 'src/entities/Trainer'
local BattleManager = require 'src/managers/BattleManager'

local PredioK = Class {}

function PredioK:init()
    self.map = sti('assets/maps/predio_k/predio_k.lua')
    self.name = "k"

    local function montarTime(ids)
        local time = {}
        for _, id in ipairs(ids) do
            table.insert(time, BattleManager.montaFeiKemon(id))
        end
        return time
    end

    self.trainers = {
        Trainer {
            nome = "Charles",
            x = -50, y = -250,
            ordem = 1,
            spritePath = 'assets/characters/Charles.png',
            retratoPath = 'assets/professores/CharlesPerfil.png',
            time = montarTime({8, 9, 10, 7}),
            timeIds = {8, 9, 10, 7},
            timeLevel = 1,
            falasPre = {
                {nome="Charles", texto="Bem-vindo ao Predio K! Vamos ver se voce entende de hardware."},
                {nome="Charles", texto="Meus FeiKemons vao te mostrar o poder dos componentes!"},
            }
        },
        Trainer {
            nome = "Luciano",
            x = 100, y = -250,
            ordem = 2,
            spritePath = 'assets/characters/Luciano.png',
            retratoPath = 'assets/professores/LucianoPerfil.png',
            time = montarTime({3, 4, 5, 2}),
            timeIds = {3, 4, 5, 2},
            timeLevel = 1,
            falasPre = {
                {nome="Luciano", texto="Software e a alma da computacao. Preparado para codar?"},
            }
        },
        Trainer {
            nome = "Leo",
            x = 250, y = -250,
            ordem = 3,
            spritePath = 'assets/characters/Leo.png',
            retratoPath = 'assets/professores/LeoPerfil.png',
            time = montarTime({6, 7, 10, 2}),
            timeIds = {6, 7, 10, 2},
            timeLevel = 1,
            falasPre = {
                {nome="Leo", texto="A rede conecta tudo. Voce nao vai escapar da minha conexao!"},
            }
        },
        Trainer {
            nome = "Plinio",
            x = 400, y = -250,
            ordem = 4,
            spritePath = 'assets/characters/Plinio.png',
            retratoPath = 'assets/professores/PlinioPerfil.png',
            time = montarTime({11, 13, 15, 12}),
            timeIds = {11, 13, 15, 12},
            timeLevel = 1,
            falasPre = {
                {nome="Plinio", texto="Energia e o que mantem o codigo rodando. Vamos la!"},
            }
        },
        Trainer {
            nome = "Leila",
            x = 16, y = -376,
            ordem = 5,
            -- spritePath = 'assets/characters/Leila.png',
            spritePath = 'assets/characters/Plinio.png',
            retratoPath = 'assets/professores/LeilaPerfil.png',
            time = montarTime({1, 6, 11, 15}),
            timeIds = {1, 6, 11, 15},
            timeLevel = 1,
            falasPre = {
                {nome="Leila", texto="Sou a chefe do departamento. So passa quem me derrotar!"},
                {nome="Leila", texto="Mostre todo o seu potencial!"},
            },
            falasPos = {
                {nome="Leila", texto="Incrivel... voce realmente e especial. A sala dos mestres esta aberta."},
            }
        },
    }
end

function PredioK:setColliders()
    self.colliders = {}

    if self.map.layers["Collision"] then
        for i, obj in pairs(self.map.layers["Collision"].objects) do
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

function PredioK:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

function PredioK:update(dt)
    if self.trainers then
        for _, trainer in ipairs(self.trainers) do
            trainer:update(dt)
        end
    end
end

function PredioK:draw()
    if self.map.layers["Ground and walls"] then
        self.map:drawLayer(self.map.layers["Ground and walls"])
    end
    if self.trainers then
        for _, trainer in ipairs(self.trainers) do
            trainer:draw()
        end
    end
end

return PredioK
