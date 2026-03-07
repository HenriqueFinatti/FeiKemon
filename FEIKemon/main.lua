---@diagnostic disable: undefined-global

local Push = require 'src.libs.push'
local StartScene = require 'src.states.StartScene'
local gameState = "Menu"
local VIRTUAL_WIDTH = 1280
local VIRTUAL_HEIGHT = 720
local WINDOW_WIDTH = 1280
local WINDOW_HEIGHT = 720

function love.load()
    StartScene.load()
    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)

end

function love.draw()
    Push:start()
    if gameState == "Menu" then
        StartScene.draw()
    end
    Push:finish()
end