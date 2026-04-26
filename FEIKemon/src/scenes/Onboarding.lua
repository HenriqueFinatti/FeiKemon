local Class = require 'src/utils/Class'
local SalaDeEstudos = require 'src/maps/SalaDeEstudos' 

local sala_de_estudos = nil
local Onboarding = Class {}

function Onboarding:init()
    self.sala_de_estudos = SalaDeEstudos()
    self.camX = -16
    self.camY = 165
    self.targetX = -209
    self.targetY = -107
    self.speed = 80
    self.step = "moveX"
end

function Onboarding:update(dt)
    self.sala_de_estudos.map:update(dt)

    if self.step == "moveX" then
        local direcao = (self.targetX > self.camX) and 1 or -1
        self.camX = self.camX + (direcao * self.speed * dt)
        
        if math.abs(self.targetX - self.camX) < 1 then
            self.camX = self.targetX 
            self.step = "moveY"
        end
    elseif self.step == "moveY" then
        local direcao = (self.targetY > self.camY) and 1 or -1
        self.camY = self.camY + (direcao * self.speed * dt)
        
        if math.abs(self.targetY - self.camY) < 1 then
            self.camY = self.targetY
            GamePhase = "Gameplay"
        end
    end

    Cam:lookAt(self.camX, self.camY)
end


function Onboarding:draw()
    self.sala_de_estudos:draw()
end

return Onboarding 