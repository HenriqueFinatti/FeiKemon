local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local SalaDeEstudos = Class {}

function SalaDeEstudos:init()
    self.map = sti('assets/maps/igreja/igreja_fei.lua')
end

function SalaDeEstudos:setColliders()
    local colliders = {}
    if self.map.layers["Colisao"] then
        for i, obj in pairs(self.map.layers["Colisao"].objects) do
            local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType('static')

            table.insert(colliders, collider)
        end
    end
end

function SalaDeEstudos:draw()
    self.map:drawLayer(self.map.layers["Colisao"])
    self.map:drawLayer(self.map.layers["Piso"])
    self.map:drawLayer(self.map.layers["Parede"])
    self.map:drawLayer(self.map.layers["Banco"])
    self.map:drawLayer(self.map.layers["Itens_Igreja"])
    -- self.map:drawLayer(self.map.layers["Chairs"])
    -- self.map:drawLayer(self.map.layers["Decoration"])
    -- self.map:drawLayer(self.map.layers["NPCs"])
end

return SalaDeEstudos