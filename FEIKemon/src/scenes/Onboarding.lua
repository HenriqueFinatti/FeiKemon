local Class = require 'src/utils/Class'
local SalaDeEstudos = require 'src/maps/SalaDeEstudos'
local sala_de_estudos = nil
local Onboarding = Class {}

local charles, danilo, leila, leo, luciano, plinio, fagner = nil, nil, nil, nil, nil, nil, nil
local Charles = require 'src/entities/Charles'
local Danilo = require 'src/entities/Danilo'
local Leila = require 'src/entities/Leila'
local Leo = require 'src/entities/Leo'
local Luciano = require 'src/entities/Luciano'
local Plinio = require 'src/entities/Plinio'
local Fagner = require 'src/entities/Fagner'

local falasDanilo

function Onboarding:init()
    self.sala_de_estudos = SalaDeEstudos()
    self.camX = -16
    self.camY = 165
    self.targetX = -209
    self.targetY = -107
    self.speed = 80
    self.step = "moveX"

    charles = Charles()
    danilo = Danilo()
    fagner = Fagner()
    leila = Leila()
    leo = Leo()
    luciano = Luciano()
    plinio = Plinio()

    falasDanilo = {
        { nome = "Danilo", texto = "Olá, sejam todos bem vindos a FEI! A melhor faculdade de todas.", retrato = danilo.retrato },
        { nome = "Danilo", texto = "E vocês sabem por que somos a melhor? Por que temos FEIKemons!!!", retrato = danilo.retrato },
        { nome = "Danilo", texto = "FEIKemons são monstrinhos estudados aqui na faculdade, cada FEIKemon pode possuir até dois tipos", retrato = danilo.retrato },
    }

    TextBoxManagerGlobal:setFalas(falasDanilo, 3)
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
            TextBoxManagerGlobal.dialogoAtivo = true
        end
    end

    if not TextBoxManagerGlobal.dialogoAtivo then
        Cam:lookAt(self.camX, self.camY)
    end

    TextBoxManagerGlobal:update(dt)
end


function Onboarding:draw()
    self.sala_de_estudos:draw()

    charles:draw(-322, -155)
    danilo:draw(-306, -155)
    fagner:draw(-290, -155)
    leila:draw(-274, -155)
    leo:draw(-258, -155)
    luciano:draw(-242, -155)
    plinio:draw(-146, -155)

    TextBoxManagerGlobal:draw()
end

return Onboarding