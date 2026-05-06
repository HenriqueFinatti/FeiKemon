---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local sti = require 'src/libs/sti'
local windfield = require 'src/libs/windfield'

local player = nil
local Player = require 'src/entities/Player'
local sala_de_estudos = nil
local SalaDeEstudos = require 'src/maps/SalaDeEstudos'

local onboarding = nil
local Onboarding = require 'src/scenes/Onboarding'

local Gameplay = {}

local larguraJogo = 512
local alturaJogo = 216

GamePhase = "Onboarding"

function Gameplay.load()
    local escalaX, escalaY
    World = windfield.newWorld(0, 0)

    love.graphics.setDefaultFilter("nearest", "nearest")

    escalaX = love.graphics.getWidth()  / larguraJogo
    escalaY = love.graphics.getHeight() / alturaJogo

    Cam = camera()
    Cam:zoomTo(math.min(escalaX, escalaY) + 2.5)

    onboarding = Onboarding()
    sala_de_estudos = SalaDeEstudos()
    sala_de_estudos:setColliders()

    player = Player(-16, 165, World)
end

function Gameplay.update(dt)

    if GamePhase == "Onboarding" then
        onboarding:update(dt)
    end
    if GamePhase == "Gameplay" then
        player:update(dt)

        World:update(dt)
        Cam:lookAt(player.x, player.y)
        -- print(player.x, player.y)
        sala_de_estudos.map:update(dt)
    end
end

function Gameplay.draw()
    Cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        if GamePhase == "Onboarding" then
            onboarding:draw()
        elseif GamePhase == "Gameplay" then
            sala_de_estudos:draw()
            player:draw()
        end
    Cam:detach()
end

function Gameplay.music()
    local music = love.audio.newSource("assets/sounds/Cloud Country.mp3", "stream")

    music:setLooping(true)
    music:setVolume(0.5)
    music:play()
end

return Gameplay