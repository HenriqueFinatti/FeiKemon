local Class = require 'src/utils/Class'
local anim8 = require 'src/libs/anim8'

local Plinio = Class {}

local SPRITE_WIDTH  = 12
local SPRITE_HEIGHT = 18

function Plinio:init()
    self.sheet = love.graphics.newImage('assets/characters/Plinio.png')
    local grid = anim8.newGrid(16, 32, self.sheet:getWidth(), self.sheet:getHeight())
    
    self.anim = anim8.newAnimation(grid('1-4', 1), 0.1)
end

function Plinio:update(dt)
end

function Plinio:draw(x, y)
    self.anim:draw(self.sheet, x, y)
end

return Plinio