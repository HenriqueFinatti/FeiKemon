local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local SalaDeEstudos = Class {}

function SalaDeEstudos:init()
    self.map = sti('assets/maps/sala_de_estudos/sala_estudos.lua')
end

function SalaDeEstudos:setColliders()
    self.colliders = {}

    if self.map.layers["Collision"] then
        for i, obj in pairs(self.map.layers["Collision"].objects) do
            local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType('static')
            collider:setCollisionClass('Obstaculo')

            table.insert(self.colliders, collider)
        end
    end

    if self.map.layers["Portas"] then
        for i, obj in pairs(self.map.layers["Portas"].objects) do
            local item = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            item:setType('static')
            item:setCollisionClass('Portas')
            item:setObject(obj)

            item.destino = obj.properties["destino"]

            table.insert(self.colliders, item)
        end
    end
end

function SalaDeEstudos:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

function SalaDeEstudos:draw()
    self.map:drawLayer(self.map.layers["Collision"])
    self.map:drawLayer(self.map.layers["Portas"])
    self.map:drawLayer(self.map.layers["Ground And Walls"])
    self.map:drawLayer(self.map.layers["Stage"])
    self.map:drawLayer(self.map.layers["Shadows"])
    self.map:drawLayer(self.map.layers["Desks"])
    self.map:drawLayer(self.map.layers["Chairs"])
    self.map:drawLayer(self.map.layers["Decoration"])
    self.map:drawLayer(self.map.layers["NPCs"])
end

return SalaDeEstudos