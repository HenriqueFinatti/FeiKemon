---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local sti = require 'src/libs/sti'
local windfield = require 'src/libs/windfield'

local player = nil
local Player = require 'src/entities/Player'
local Gameplay = {}

local larguraJogo = 512
local alturaJogo = 216

local sala_estudos
local world, cam

function Gameplay.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    local escalaX = love.graphics.getWidth()  / larguraJogo
    local escalaY = love.graphics.getHeight() / alturaJogo
    local sheet = love.graphics.newImage('assets/player/player-sheet.png')

    world = windfield.newWorld(0, 0)
    cam = camera()
    sala_estudos = sti('assets/maps/sala_de_estudos/sala_estudos.lua')

    player = Player(-16, 165, world)

    cam:zoomTo(math.min(escalaX, escalaY) + 2.5)
    player:setAnimations(sheet)

    local colliders = {}
    if sala_estudos.layers["Collision"] then
        for i, obj in pairs(sala_estudos.layers["Collision"].objects) do
            local collider = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            collider:setType('static')

            table.insert(colliders, collider)
        end
    end
end

function Gameplay.update(dt)
    player:update(dt)

    world:update(dt)
    cam:lookAt(player.x, player.y)
    sala_estudos:update(dt)
end

function Gameplay.draw()
    cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        sala_estudos:drawLayer(sala_estudos.layers["Collision"])
        sala_estudos:drawLayer(sala_estudos.layers["Ground And Walls"])
        sala_estudos:drawLayer(sala_estudos.layers["Stage"])
        sala_estudos:drawLayer(sala_estudos.layers["Shadows"])
        sala_estudos:drawLayer(sala_estudos.layers["Desks"])
        sala_estudos:drawLayer(sala_estudos.layers["Chairs"])
        sala_estudos:drawLayer(sala_estudos.layers["Decoration"])

        -- world:draw()
        player.anim:draw(player.sheet, player.x, player.y, nil, 1.5, nil, 6, 9)
    cam:detach()
end

function Gameplay.music()
    local music = love.audio.newSource("assets/sounds/Cloud Country.mp3", "stream")

    music:setLooping(true)
    music:setVolume(0.5)

    music:play()
end

return Gameplay