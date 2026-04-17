---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local sti = require 'src/libs/sti'
local windfield = require 'src/libs/windfield'
local anim8 = require 'src/libs/anim8'

local Gameplay = {}

local larguraJogo     = 512
local alturaJogo     = 216

local SPRITE_WIDTH  = 12
local SPRITE_HEIGHT = 18
local SPEED         = 80

local sala_estudos
local player = {}

function Gameplay.load()
    world = windfield.newWorld(0, 0)
    cam = camera()
    sala_estudos = sti('assets/maps/sala_de_estudos/sala_estudos.lua')

    love.graphics.setDefaultFilter("nearest", "nearest")

    local escalaX = love.graphics.getWidth()  / larguraJogo
    local escalaY = love.graphics.getHeight() / alturaJogo

    cam:zoomTo(math.min(escalaX, escalaY) + 2.5)

    local sheet = love.graphics.newImage('assets/player/player-sheet.png')
    local grid = anim8.newGrid(SPRITE_WIDTH, SPRITE_HEIGHT, sheet:getWidth(), sheet:getHeight())
    local animationSpeed = 0.1

    player.animations = {
        down  = anim8.newAnimation(grid('1-4', 1), animationSpeed),
        left  = anim8.newAnimation(grid('1-4', 2), animationSpeed),
        right = anim8.newAnimation(grid('1-4', 3), animationSpeed),
        up    = anim8.newAnimation(grid('1-4', 4), animationSpeed),
    }
    player.sheet     = sheet
    player.anim      = player.animations.down
    player.direction = 'down'
    player.x         = -16
    player.y         = 165
    player.moving    = false
    player.collider  = world:newBSGRectangleCollider(player.x, player.y, 15, 30, 1)

    player.collider:setFixedRotation(true)
end

function Gameplay.update(dt)
    local dx, dy = 0, 0

    player.moving = false
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        dy = -SPEED
        player.direction = 'up'
        player.moving    = true
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        dy = SPEED
        player.direction = 'down'
        player.moving    = true
    end

    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        dx = -SPEED
        player.direction = 'left'
        player.moving    = true
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        dx = SPEED
        player.direction = 'right'
        player.moving    = true
    end

    player.x = player.x + dx
    player.y = player.y + dy

    local targetAnim = player.animations[player.direction]
    if player.anim ~= targetAnim then
        player.anim = targetAnim
        player.anim:resume()
    end

    if player.moving then
        player.anim:update(dt)
    else
        player.anim:gotoFrame(1)
    end

    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.collider:setLinearVelocity(dx, dy)

    world:update(dt)
    cam:lookAt(player.x, player.y)
    sala_estudos:update(dt)
end

function Gameplay.draw()
    cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        sala_estudos:drawLayer(sala_estudos.layers["Ground And Walls"])
        sala_estudos:drawLayer(sala_estudos.layers["Stage"])
        sala_estudos:drawLayer(sala_estudos.layers["Shadows"])
        sala_estudos:drawLayer(sala_estudos.layers["Desks"])
        sala_estudos:drawLayer(sala_estudos.layers["Chairs"])
        sala_estudos:drawLayer(sala_estudos.layers["Decoration"])

        world:draw()
        player.anim:draw(player.sheet, player.x, player.y, nil, 1.5, nil, 6, 9)
    cam:detach()
end

return Gameplay