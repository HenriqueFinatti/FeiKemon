local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local MacFEI = Class {}

function MacFEI:init()
    self.map = sti('assets/maps/macfei/macfei.lua')
    self.name = "macfei"
end

function MacFEI:setColliders()
    self.colliders = {}

    if self.map.layers["Colisao"] then
        for i, obj in pairs(self.map.layers["Colisao"].objects) do
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
            item.x = obj.properties["x"]
            item.y = obj.properties["y"]

            table.insert(self.colliders, item)
        end
    end
end

function MacFEI:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

function MacFEI:draw()
    self.map:drawLayer(self.map.layers["Piso"])
    self.map:drawLayer(self.map.layers["Parede"])
    self.map:drawLayer(self.map.layers["Cozinha"])
    self.map:drawLayer(self.map.layers["Mesas"])
    self.map:drawLayer(self.map.layers["Auxiliares"])
end

return MacFEI