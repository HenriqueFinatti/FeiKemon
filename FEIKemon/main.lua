---@diagnostic disable: undefined-global
local sti = require 'src/libs/sti'
local StartScene = require 'src.states.StartScene'
local Transition = require 'src.states.Transition'
local gameState = "Menu"

function love.load()
    StartScene.load()
    sala_estudos = sti('assets/maps/sala_de_estudos/sala_estudos.lua')
end

function love.update(dt)
    if gameState == "Transition" then
        Transition.update(dt)
    end
end

function love.mousepressed(x, y, button)
    if gameState == "Menu" then
        local action = StartScene.mousepressed(x, y, button)
        if action == "jogar" then
            Transition.load()
            gameState = "Transition"
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if gameState == "Transition" then
        local action = Transition.keypressed(key)
        if action == "iniciar_gameplay" then
            gameState = "jogo"
        end
    end
end

function love.draw()
    if gameState == "Menu" then
        StartScene.draw()
    elseif gameState == "Transition" then
        Transition.draw()
    end
end