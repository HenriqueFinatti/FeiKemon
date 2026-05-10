local Class = require 'src/utils/Class'
local anim8 = require 'src/libs/anim8'

local Player = Class {}

local SPRITE_WIDTH  = 12
local SPRITE_HEIGHT = 18
local SPEED         = 80

function Player:init()
    self.x = 0
    self.y = 0
    self.speed = SPEED
    self.moving = false
    self.healTimer = 0

    self.equipe = {}
    self.maxEquipe = 6

    self.currentMap = "sala de estudos"

    self.collider  = World:newBSGRectangleCollider(self.x, self.y, 12, 15, 1)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

    local sheet = love.graphics.newImage('assets/player/player-sheet.png')
    local grid = anim8.newGrid(SPRITE_WIDTH, SPRITE_HEIGHT, sheet:getWidth(), sheet:getHeight())
    local animationSpeed = 0.1

    self.animations = {
        down  = anim8.newAnimation(grid('1-4', 1), animationSpeed),
        left  = anim8.newAnimation(grid('1-4', 2), animationSpeed),
        right = anim8.newAnimation(grid('1-4', 3), animationSpeed),
        up    = anim8.newAnimation(grid('1-4', 4), animationSpeed),
    }
    self.sheet     = sheet
    self.anim      = self.animations.down
    self.direction = 'down'
end

function Player:obterPrimeiroVivo()
    for i, f in ipairs(self.equipe) do
        if f.hp_atual > 0 then
            return i
        end
    end
    return nil
end

function Player:captura(feikemon)
    if #self.equipe < self.maxEquipe then
        local copia = {
            nome = feikemon.nome,
            tipo = feikemon.tipo,
            foto_frente = feikemon.foto_frente,
            foto_verso = feikemon.foto_verso,
            hp_max = feikemon.hp_max,
            hp_atual = feikemon.hp_max,
            ataques = feikemon.ataques
        }
        table.insert(self.equipe, copia)
    end
end

function Player:healTeam(dt)
    self.healTimer = self.healTimer + dt

    if self.healTimer >= 1 then
        self.healTimer = self.healTimer - 1

        for _, feikemon in ipairs(self.equipe) do
            feikemon.hp_atual = math.min(feikemon.hp_max, feikemon.hp_atual + 10)
        end
    end
end

function Player:update(dt)
    local dx, dy = 0, 0
    self.moving = false

    if self.currentMap == "macfei" then
        self:healTeam(dt)
    end

    if love.keyboard.isDown('w', 'up') then
        dy = -self.speed
        self.direction = 'up'
        self.moving = true
    elseif love.keyboard.isDown('s', 'down') then
        dy = self.speed
        self.direction = 'down'
        self.moving = true
    end

    if love.keyboard.isDown('a', 'left') then
        dx = -self.speed
        self.direction = 'left'
        self.moving = true
    elseif love.keyboard.isDown('d', 'right') then
        dx = self.speed
        self.direction = 'right'
        self.moving = true
    end

    self.collider:setLinearVelocity(dx, dy)

    self.x = self.collider:getX()
    self.y = self.collider:getY()
    -- print(self.x, self.y)
    local targetAnim = self.animations[self.direction]
    if self.anim ~= targetAnim then
        self.anim = targetAnim
        self.anim:resume()
    end

    if self.moving then
        self.anim:update(dt)
    else
        self.anim:gotoFrame(1)
    end
end

function Player:draw()
    self.anim:draw(self.sheet, self.x, self.y, nil, 1.5, nil, 6, 9)
end

return Player