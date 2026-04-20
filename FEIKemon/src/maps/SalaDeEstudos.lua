local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local SalaDeEstudos = Class {}

function SalaDeEstudos:init()
    self.map = sti('assets/maps/sala_de_estudos/sala_estudos.lua')
end

function SalaDeEstudos:setColliders()
    local colliders = {}
    if self.map.layers["Collision"] then
        for i, obj in pairs(self.map.layers["Collision"].objects) do
            local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType('static')

            table.insert(colliders, collider)
        end
    end
end

function SalaDeEstudos:draw()
    self.map:drawLayer(self.map.layers["Collision"])
    self.map:drawLayer(self.map.layers["Ground And Walls"])
    self.map:drawLayer(self.map.layers["Stage"])
    self.map:drawLayer(self.map.layers["Shadows"])
    self.map:drawLayer(self.map.layers["Desks"])
    self.map:drawLayer(self.map.layers["Chairs"])
    self.map:drawLayer(self.map.layers["Decoration"])
end

return SalaDeEstudos