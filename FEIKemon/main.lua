---@diagnostic disable: undefined-global

local Push = require 'src.libs.push'
local StartScene = require 'src.states.StartScene'
local gameState = "Menu"
local VIRTUAL_WIDTH = 1366
local VIRTUAL_HEIGHT = 768
local WINDOW_WIDTH = 1366
local WINDOW_HEIGHT = 768

function love.load()
    StartScene.load()
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false,
        highdpi = true
    })
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)

end

function love.mousepressed(x, y, button)
    if gameState == "Menu" then
        local action = StartScene.mousepressed(x, y, button)
        if action == "jogar" then
            gameState = "jogo"
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.draw()
    Push:start()
    if gameState == "Menu" then
        StartScene.draw()
    elseif gameState == "jogo" then
        love.graphics.print("Você está no jogo!", 100, 100)
    end
    Push:finish()
end