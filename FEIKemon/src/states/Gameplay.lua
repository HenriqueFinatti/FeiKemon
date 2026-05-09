---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local Player = require 'src/entities/Player'
local Onboarding = require 'src/scenes/Onboarding'
local Transition = require 'src/utils/Transition'
local BattleManager = require 'src/managers/BattleManager'
local MapManager = require 'src/managers/MapManager'

Gameplay = {}

local VIRTUAL_WIDTH = 512
local VIRTUAL_HEIGHT = 216

GamePhase = "Gameplay"

function Gameplay.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Gameplay.loadCamera()
    Gameplay.onboarding = Onboarding()

    local inicial = BattleManager.montaFeiKemon(1)
    local portaInicial = {
        destino = "sala de estudos",
        x = -16,
        y = 165
    }

    Gameplay.player = Player(-16, 165)
    Gameplay.player:captura(inicial)
    MapManager.mudarMapa(portaInicial, Gameplay)
end

function Gameplay.update(dt)
    Transition.update(dt)

    if GamePhase == "Onboarding" then
        Gameplay.onboarding:update(dt)

    elseif GamePhase == "Gameplay" then
        World:update(dt)

        local collider = Gameplay.player.collider
        if Transition.state == "none" and collider:enter('Portas') then
            local porta = collider:getEnterCollisionData('Portas').collider
            Transition.start(3, function() MapManager.mudarMapa(porta, Gameplay) end)
        end

        Gameplay.player:update(dt)
        Cam:lookAt(Gameplay.player.x, Gameplay.player.y)
        BattleManager.check(dt, Gameplay)
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

    Transition.draw()
end

function Gameplay.loadCamera()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local escala = math.min(sw / VIRTUAL_WIDTH, sh / VIRTUAL_HEIGHT)

    Cam = camera()
    Cam:zoomTo(escala + 2.5)
end

return Gameplay