local Class = require 'src/utils/Class'
local anim8 = require 'src/libs/anim8'

local Trainer = Class {}

function Trainer:init(config)
    self.nome = config.nome
    self.x = config.x
    self.y = config.y
    self.derrotado = config.derrotado or false
    self.ordem = config.ordem or 1
    self.isNpc = config.isNpc or false

    self.sheet = love.graphics.newImage(config.spritePath)
    local sw, sh = self.sheet:getWidth(), self.sheet:getHeight()

    -- Se for marcado como sprite estatico, nao usa anim8
    print("[TRAINER INIT]", config.nome, "isStaticSprite:", tostring(config.isStaticSprite), "sprite:", config.spritePath)
    if config.isStaticSprite then
        self.anim = nil
        -- Tamanho desejado na tela para sprites estaticos
        self.drawW = 32
        self.drawH = 32 * (sh / sw)  -- mantem proporcao
        print("[TRAINER INIT]", config.nome, "-> MODO ESTATICO, drawW:", self.drawW, "drawH:", self.drawH)
    else
        local grid = anim8.newGrid(16, 32, sw, sh)
        self.anim = anim8.newAnimation(grid('1-4', 1), 0.1)
        self.drawW = 16
        self.drawH = 32
        print("[TRAINER INIT]", config.nome, "-> MODO ANIMADO")
    end

    self.retrato = love.graphics.newImage(config.retratoPath)

    self.time = config.time or {}
    self.timeIds = config.timeIds or {}
    self.timeLevel = config.timeLevel or 1
    self.falasPre = config.falasPre or {{nome=self.nome, texto="Vamos batalhar!", retrato=self.retrato}}
    self.falasPos = config.falasPos or {{nome=self.nome, texto="Voce venceu...", retrato=self.retrato}}
    self.onComplete = config.onComplete or nil

    for _, f in ipairs(self.falasPre) do
        if not f.retrato then f.retrato = self.retrato end
    end
    for _, f in ipairs(self.falasPos) do
        if not f.retrato then f.retrato = self.retrato end
    end
end

function Trainer:rebuildTime(level)
    if not self.timeIds or #self.timeIds == 0 then return end
    local BattleManager = require 'src/managers/BattleManager'
    self.time = {}
    for _, id in ipairs(self.timeIds) do
        table.insert(self.time, BattleManager.montaFeiKemon(id, level))
    end
    self.derrotado = false
end

function Trainer:update(dt)
    if self.anim then
        self.anim:update(dt)
    end
end

function Trainer:draw()
    if not self.derrotado then
        if self.anim then
            self.anim:draw(self.sheet, self.x, self.y)
        else
            local escala = self.drawW / self.sheet:getWidth()
            love.graphics.draw(self.sheet, self.x, self.y, 0, escala, escala)
        end
    end
end

function Trainer:estaPerto(px, py)
    local cx = self.x + self.drawW * 0.5
    local cy = self.y + self.drawH * 0.5
    local dx = math.abs(px - cx)
    local dy = math.abs(py - cy)
    return dx < 40 and dy < 40
end

return Trainer
