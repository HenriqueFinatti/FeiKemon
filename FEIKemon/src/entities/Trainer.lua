local Class = require 'src/utils/Class'
local anim8 = require 'src/libs/anim8'

local Trainer = Class {}

function Trainer:init(config)
    self.nome = config.nome
    self.x = config.x
    self.y = config.y
    self.derrotado = config.derrotado or false
    self.ordem = config.ordem or 1

    self.sheet = love.graphics.newImage(config.spritePath)
    local grid = anim8.newGrid(16, 32, self.sheet:getWidth(), self.sheet:getHeight())
    self.anim = anim8.newAnimation(grid('1-4', 1), 0.1)

    self.retrato = love.graphics.newImage(config.retratoPath)

    self.time = config.time or {}
    self.falasPre = config.falasPre or {{nome=self.nome, texto="Vamos batalhar!", retrato=self.retrato}}
    self.falasPos = config.falasPos or {{nome=self.nome, texto="Voce venceu...", retrato=self.retrato}}

    for _, f in ipairs(self.falasPre) do
        if not f.retrato then f.retrato = self.retrato end
    end
    for _, f in ipairs(self.falasPos) do
        if not f.retrato then f.retrato = self.retrato end
    end
end

function Trainer:update(dt)
    self.anim:update(dt)
end

function Trainer:draw()
    if not self.derrotado then
        self.anim:draw(self.sheet, self.x, self.y)
    end
end

function Trainer:estaPerto(px, py)
    -- centro do sprite do treinador (16x32)
    local cx = self.x + 8
    local cy = self.y + 16
    local dx = math.abs(px - cx)
    local dy = math.abs(py - cy)
    return dx < 35 and dy < 35
end

return Trainer
