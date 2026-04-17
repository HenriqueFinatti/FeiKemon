---@diagnostic disable: undefined-global
local anim8 = require 'src/libs/anim8'
local sti = require 'src/libs/sti'
local canvas
local camX = -256
local camY = 0

local Gameplay = {}

local larguraJogo     = 512
local alturaJogo     = 216

local SPRITE_WIDTH  = 12
local SPRITE_HEIGHT = 18
local SPEED         = 80

local sala_estudos
local player = {}
local camera = {}
local canvas

function Gameplay.load()
    sala_estudos = sti('assets/maps/sala_de_estudos/sala_estudos.lua')

    love.graphics.setDefaultFilter("nearest", "nearest")
    canvas = love.graphics.newCanvas(larguraJogo, alturaJogo)

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
    player.x         = 100
    player.y         = 100
    player.moving    = false

    camera.mapW = sala_estudos.width  * sala_estudos.tilewidth
    camera.mapH = sala_estudos.height * sala_estudos.tileheight
    camera.x    = 0
    camera.y    = 0
end

function Gameplay.update(dt)
    local dx, dy = 0, 0
    player.moving = false

    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        dy = -SPEED * dt
        player.direction = 'up'
        player.moving    = true
    elseif love.keyboard.isDown('s') or love.keyboard.isDown('down') then
        dy = SPEED * dt
        player.direction = 'down'
        player.moving    = true
    end

    if love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        dx = -SPEED * dt
        player.direction = 'left'
        player.moving    = true
    elseif love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        dx = SPEED * dt
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

    sala_estudos:update(dt)
end

function Gameplay.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)

    sala_estudos:draw(-camX, -camY)

    love.graphics.push()
    love.graphics.translate(-camX, -camY)
    love.graphics.pop()

    player.anim:draw(player.sheet, player.x, player.y,  0, 1)

    love.graphics.setCanvas()

    local larguraMonitor = love.graphics.getWidth()
    local alturaMonitor = love.graphics.getHeight()

    local escalaX = larguraMonitor / larguraJogo
    local escalaY = alturaMonitor / alturaJogo

    local escalaFinal = math.min(escalaX, escalaY)

    local offsetX = (larguraMonitor - (larguraJogo * escalaFinal)) / 2
    local offsetY = (alturaMonitor - (alturaJogo * escalaFinal)) / 2

    love.graphics.draw(canvas, offsetX, offsetY, 0, escalaFinal, escalaFinal)
end

return Gameplay