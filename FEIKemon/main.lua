---@diagnostic disable: undefined-global
local sti = require 'src/libs/sti'

local Menu = require 'src.states.Menu'
local Transition = require 'src.states.Transition'

gameState = "Menu"

function love.load()
    Menu.load()
    Transition.load()

    sala_estudos = sti('assets/maps/sala_de_estudos/sala_estudos.lua')
end

function love.update(dt)
    if gameState == "Transition" then
        Transition.update(dt)
    end
end

function love.mousepressed(x, y, button)
    if gameState == "Menu" then
        local action = Menu.mousepressed(x, y, button)

        if action == "jogar" then
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
        Menu.draw()

    elseif gameState == "Transition" then
        Transition.draw()

    elseif gameState == "iniciar_gameplay"
    end
end