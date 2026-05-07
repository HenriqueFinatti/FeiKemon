local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local AreaExterna = Class {}

function AreaExterna:init()
    self.map = sti('assets/maps/area_externa/area_externa.lua')
end

function AreaExterna:setColliders()
    self.colliders = {}

    if self.map.layers["Collision"] then
        for i, obj in pairs(self.map.layers["Collision"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                collider:setType('static')

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

function AreaExterna:draw()
    self.map:drawLayer(self.map.layers["Base"])
    self.map:drawLayer(self.map.layers["Predios"])
    self.map:drawLayer(self.map.layers["Decoracao"])
end

function AreaExterna:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

return AreaExterna