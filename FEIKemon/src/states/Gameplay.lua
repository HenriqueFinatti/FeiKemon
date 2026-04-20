---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local sti = require 'src/libs/sti'
local windfield = require 'src/libs/windfield'

local player = nil
local Player = require 'src/entities/Player'
local sala_de_estudos = nil
local SalaDeEstudos = require 'src/maps/SalaDeEstudos'

local Gameplay = {}

local larguraJogo = 512
local alturaJogo = 216
local cam

function Gameplay.load()
    local sheet, escalaX, escalaY
    World = windfield.newWorld(0, 0)

    love.graphics.setDefaultFilter("nearest", "nearest")

    sheet = love.graphics.newImage('assets/player/player-sheet.png')
    escalaX = love.graphics.getWidth()  / larguraJogo
    escalaY = love.graphics.getHeight() / alturaJogo

    cam = camera()
    cam:zoomTo(math.min(escalaX, escalaY) + 2.5)

    sala_de_estudos = SalaDeEstudos()
    sala_de_estudos:setColliders()

    player = Player(-16, 165, World)
    player:setAnimations(sheet)

end

function Gameplay.update(dt)
    player:update(dt)

    World:update(dt)
    cam:lookAt(player.x, player.y)
    sala_de_estudos.map:update(dt)
end

function Gameplay.draw()
    cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        sala_de_estudos:draw()
        player:draw()
    cam:detach()
end

function Gameplay.music()
    local music = love.audio.newSource("assets/sounds/Cloud Country.mp3", "stream")

    music:setLooping(true)
    music:setVolume(0.5)
    music:play()
end

return Gameplay