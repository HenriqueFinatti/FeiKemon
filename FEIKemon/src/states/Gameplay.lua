---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local Player = require 'src/entities/Player'
local Onboarding = require 'src/scenes/Onboarding'

local player = nil
local onboarding = nil

local mapas = {
    ["sala de estudos"] = require 'src/maps/SalaDeEstudos',
    ["area externa"]    = require 'src/maps/AreaExterna'
}

local Gameplay = {}

local VIRTUAL_WIDTH = 512
local VIRTUAL_HEIGHT = 216

local transition = {
    alpha = 0,
    state = "none",
    speed = 3,
    nextMap = nil,
    nextX = 0,
    nextY = 0
}

GamePhase = "Gameplay"

function Gameplay.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Gameplay.loadCamera()
    Gameplay.onboarding = Onboarding()

    Gameplay.player = Player(-16, 165, World)
    Gameplay.mudarMapa("sala de estudos", -16, 165)
end

function Gameplay.update(dt)

    Gameplay.transition(dt)

    if GamePhase == "Onboarding" then
        Gameplay.onboarding:update(dt)

    elseif GamePhase == "Gameplay" then
        World:update(dt)

        if transition.state == "none" and Gameplay.player.collider:enter('Portas') then
            local porta = Gameplay.player.collider:getEnterCollisionData('Portas')
            local p = porta.collider

            transition.nextMap = p.destino
            transition.nextX = p.x
            transition.nextY = p.y
            transition.state = "out"
        end

        Gameplay.player:update(dt)
        Cam:lookAt(Gameplay.player.x, Gameplay.player.y)
    end
end

function Gameplay.draw()
    Cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1,1,1,1)

        if GamePhase == "Onboarding" then
            Gameplay.onboarding:draw()
        else
            if Gameplay.mapaAtual then Gameplay.mapaAtual:draw() end
            if Gameplay.player then Gameplay.player:draw() end
        end
    Cam:detach()

    Gameplay.drawTransition()
end

function Gameplay.mudarMapa(nome, sx, sy)
    if Gameplay.mapaAtual and Gameplay.mapaAtual.removeColliders then
        Gameplay.mapaAtual:removeColliders()
    end

    local MapaClasse = mapas[nome]
    if MapaClasse then
        Gameplay.mapaAtual = MapaClasse()
        Gameplay.mapaAtual:setColliders()
    end

    Gameplay.player.collider:setPosition(sx, sy)
end

function Gameplay.drawTransition()
    if transition.alpha > 0 then
        love.graphics.setColor(0, 0, 0, transition.alpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function Gameplay.transition(dt)
    if transition.state == "out" then
        transition.alpha = math.min(transition.alpha + transition.speed * dt, 1)
        if transition.alpha >= 1 then
            Gameplay.mudarMapa(transition.nextMap, transition.nextX, transition.nextY)
            transition.state = "in"
        end
        return

    elseif transition.state == "in" then
        transition.alpha = math.max(transition.alpha - transition.speed * dt, 0)
        if transition.alpha <= 0 then
            transition.state = "none"
        end
    end
end

function Gameplay.loadCamera()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local escala = math.min(sw / VIRTUAL_WIDTH, sh / VIRTUAL_HEIGHT)

    Cam = camera()
    Cam:zoomTo(escala + 2.5)
end

function Gameplay.music()
    local music = love.audio.newSource("assets/sounds/Cloud Country.mp3", "stream")

    music:setLooping(true)
    music:setVolume(0.5)
    music:play()
end

return Gameplay