---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local sti = require 'src/libs/sti'

local player = nil
local Player = require 'src/entities/Player'
local sala_de_estudos = nil
local SalaDeEstudos = require 'src/maps/SalaDeEstudos'

local area_externa = nil
local AreaExterna = require 'src/maps/AreaExterna'

local onboarding = nil
local Onboarding = require 'src/scenes/Onboarding'

local Gameplay = {}

local larguraJogo = 512
local alturaJogo = 216

GamePhase = "Gameplay"

function Gameplay.load()
    local escalaX, escalaY

    love.graphics.setDefaultFilter("nearest", "nearest")

    escalaX = love.graphics.getWidth()  / larguraJogo
    escalaY = love.graphics.getHeight() / alturaJogo

    Cam = camera()
    Cam:zoomTo(math.min(escalaX, escalaY) + 2.5)

    -- onboarding = Onboarding() PRECISO CORRIGIR ISSO

    mapaAtual = SalaDeEstudos()
    area_externa = AreaExterna()

    player = Player(-16, 165, World)
end

function mudarMapa(nomeNovoMapa, spawnX, spawnY)
    -- 1. Destrói os colisores do mapa antigo
    if mapaAtual and mapaAtual.destruirFisica then
        mapaAtual:destruirFisica()
    end

    -- 2. Carrega a nova classe do mapa
    if nomeNovoMapa == "area externa" then
        mapaAtual = AreaExterna() 
    elseif nomeNovoMapa == "sala de estudos" then
        mapaAtual = SalaDeEstudos()
    end

    -- 3. Move o player para a nova posição (o collider dele continua existindo!)
    player.collider:setPosition(spawnX, spawnY)
end

function Gameplay.update(dt)

    if GamePhase == "Onboarding" then
        onboarding:update(dt)
    end

    if GamePhase == "Gameplay" then
        World:update(dt)

        if player.collider:enter('Portas') then
            local collisionData = player.collider:getEnterCollisionData('Portas')

            local destino = collisionData.collider.destino
            local sx = collisionData.collider.spawn_x
            local sy = collisionData.collider.spawn_y

            mudarMapa(destino, -16, 165)
        end

        player:update(dt)
        Cam:lookAt(player.x, player.y)
    end
end

function Gameplay.draw()
    Cam:attach()
        love.graphics.clear()
        love.graphics.setColor(1, 1, 1, 1)

        if GamePhase == "Onboarding" then
            onboarding:draw()
        elseif GamePhase == "Gameplay" then
            World:draw()
            mapaAtual:draw()
            -- if player.currentMap == "sala de estudos" then
            --     sala_de_estudos:draw()
            -- elseif player.currentMap == "area externa" then
            --     area_externa:draw()
            -- end

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