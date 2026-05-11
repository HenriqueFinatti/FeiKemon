local Class = require 'src/utils/Class'
local sti = require 'src/libs/sti'

local IgrejaFEI = Class {}

function IgrejaFEI:init()
    self.map = sti('assets/maps/igreja/igreja_fei.lua')
    self.name = "igreja"
end

function IgrejaFEI:setColliders()
    self.colliders = {}

    if self.map.layers["Colisao"] then
        for i, obj in pairs(self.map.layers["Colisao"].objects) do
            if obj.width > 0 and obj.height > 0 then
                local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
                collider:setType('static')
                collider:setCollisionClass('Obstaculo')
                table.insert(self.colliders, collider)
            end
        end
    end

    if self.map.layers["Portas"] then
        for i, obj in pairs(self.map.layers["Portas"].objects) do
            if obj.width > 0 and obj.height > 0 then
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
end

function IgrejaFEI:draw()
    if self.map.layers["Piso"] then
        self.map:drawLayer(self.map.layers["Piso"])
    end
    if self.map.layers["Parede"] then
        self.map:drawLayer(self.map.layers["Parede"])
    end
    if self.map.layers["Banco"] then
        self.map:drawLayer(self.map.layers["Banco"])
    end
    if self.map.layers["Itens_Igreja"] then
        self.map:drawLayer(self.map.layers["Itens_Igreja"])
    end
end

function IgrejaFEI:removeColliders()
    for _, c in ipairs(self.colliders) do
        if not c:isDestroyed() then
            c:destroy()
        end
    end
    self.colliders = {}
end

return IgrejaFEI
