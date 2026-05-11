---@diagnostic disable: undefined-global
local wf = require 'src/libs/windfield'
local Menu      = require 'src.states.Menu'
local Transition = require 'src.states.Transition'
local Gameplay  = require 'src.states.Gameplay'
local gameState = "Jogo"
local BattleManager = require 'src/managers/BattleManager'
local TeamMenu = require 'src/ui/TeamMenu'
TextBoxManagerGlobal = nil
TextBoxManager = require 'src/managers/TextBoxManager'

function love.load()
    love.window.setFullscreen(true, "desktop")
    math.randomseed(os.time())
    World = wf.newWorld(0, 0, true)

    World:addCollisionClass('Player')
    World:addCollisionClass('Portas')
    World:addCollisionClass('Obstaculo')

    TextBoxManagerGlobal = TextBoxManager()

    Menu.load()
    Transition.load()
    Gameplay.load()
    TeamMenu.load()
    music()
end

function love.update(dt)
    if gameState == "Transition" then
        Transition.update(dt)
    elseif gameState == "Jogo" then
        Gameplay.update(dt)
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
    if GamePhase == "Battle" then
        BattleManager.controles(key)
    end

    if key == "e" and GamePhase == "Gameplay" then
        TeamMenu.toggle()
    end

    if key == "escape" then
        love.event.quit()
    end

    if key == "return" then
        TextBoxManagerGlobal:interagir()
    end

    if gameState == "Transition" then
        local action = Transition.keypressed(key)
        if action == "iniciar_gameplay" then
            music()
            gameState = "Jogo"
        end
    end
end

function love.draw()
    if gameState == "Menu" then
        Menu.draw()
    elseif gameState == "Transition" then
        Transition.draw()
    elseif gameState == "Jogo" then
        Gameplay.draw()
    end
end

function music()
    BackgroundMusic = love.audio.newSource("assets/sounds/Background.mp3", "stream")

    BackgroundMusic:setLooping(true)
    BackgroundMusic:setVolume(0.5)
    BackgroundMusic:play()
end