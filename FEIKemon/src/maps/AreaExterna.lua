local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local AreaExterna = Class {}

function AreaExterna:init()
    self.map = sti('assets/maps/area_externa/area_externa.lua')
end

function AreaExterna:setColliders()
    local colliders = {}
    if self.map.layers["Collision"] then
        for i, obj in pairs(self.map.layers["Collision"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                collider:setType('static')
                
                table.insert(colliders, collider)
            end
        end
    end
end

function AreaExterna:draw()
    self.map:drawLayer(self.map.layers["Collision"])
    self.map:drawLayer(self.map.layers["Base"])
    self.map:drawLayer(self.map.layers["Predios"])
    self.map:drawLayer(self.map.layers["Decoracao"])
end

return AreaExterna