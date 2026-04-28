local Class = require 'src/utils/Class'
local anim8 = require 'src/libs/anim8'

local Luciano = Class {}

local SPRITE_WIDTH  = 12
local SPRITE_HEIGHT = 18

function Luciano:init()
    self.sheet = love.graphics.newImage('assets/characters/Luciano.png')
    local grid = anim8.newGrid(16, 32, self.sheet:getWidth(), self.sheet:getHeight())
    
    self.anim = anim8.newAnimation(grid('1-4', 1), 0.1)
end

function Luciano:update(dt)
end

function Luciano:draw(x, y)
    self.anim:draw(self.sheet, x, y)
end

return Luciano