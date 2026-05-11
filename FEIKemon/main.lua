---@diagnostic disable: undefined-global
local wf = require 'src/libs/windfield'
local Menu      = require 'src.states.Menu'
local Transition = require 'src.states.Transition'
Gameplay  = require 'src.states.Gameplay'
local Creditos = require 'src/scenes/Creditos'
GameState = "Menu"
local BattleManager = require 'src/managers/BattleManager'
local TeamMenu = require 'src/ui/TeamMenu'
local PauseMenu = require 'src/ui/PauseMenu'
local PCMenu = require 'src/ui/PCMenu'
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
    TeamMenu.load()
    PauseMenu.load()
    PCMenu.load()
    Creditos.load()
    music()
end

local _creditosStarted = false
function love.update(dt)
    if GameState == "Creditos" and not _creditosStarted then
        _creditosStarted = true
        Creditos.start()
    elseif GameState ~= "Creditos" then
        _creditosStarted = false
    end

    if GameState == "Transition" then
        Transition.update(dt)
    elseif GameState == "Jogo" then
        Gameplay.update(dt)
    elseif GameState == "Creditos" then
        Creditos.update(dt)
    end
    PauseMenu.update(dt)
end

function love.mousepressed(x, y, button)
    if GameState == "Menu" then
        local action = Menu.mousepressed(x, y, button)
        if action == "jogar" then
            -- Deleta save antigo para garantir jogo limpo
            local SaveManager = require 'src/managers/SaveManager'
            SaveManager.deletar()
            Gameplay.load()
            GameState = "Transition"
        elseif action == "carregar" then
            local SaveManager = require 'src/managers/SaveManager'
            if SaveManager.existeSave() then
                Gameplay.loadFromSave()
                GameState = "Jogo"
                music()
            else
                -- Sem save: comeca novo jogo
                Gameplay.load()
                GameState = "Transition"
            end
        end
    end
end

function love.keypressed(key)
    if GameState == "Creditos" then
        Creditos.keypressed(key)
        return
    end

    if GamePhase == "Battle" then
        BattleManager.controles(key)
    end

    if key == "e" and (GamePhase == "Gameplay" or GamePhase == "Dialogo") then
        TeamMenu.toggle()
    end

    if PCMenu.isVisible() then
        PCMenu.controles(key, Gameplay.player)
        return
    end

    if key == "t" and GamePhase == "Gameplay" then
        PCMenu.toggle()
        return
    end

    if key == "escape" then
        if GamePhase == "Pause" then
            PauseMenu.toggle()
        elseif GamePhase ~= "Battle" and GamePhase ~= "Onboarding" then
            PauseMenu.toggle()
        end
    end

    if PauseMenu.ativo then
        PauseMenu.controles(key)
        return
    end

    if key == "return" or key == "space" then
        TextBoxManagerGlobal:interagir()
    end

    if key == "space" and GamePhase == "Gameplay" then
        Gameplay.tentarInteragir()
    end

    if GameState == "Transition" then
        local action = Transition.keypressed(key)
        if action == "iniciar_gameplay" then
            music()
            GameState = "Jogo"
        end
    end
end

function love.draw()
    if GameState == "Menu" then
        Menu.draw()
    elseif GameState == "Transition" then
        Transition.draw()
    elseif GameState == "Jogo" then
        Gameplay.draw()
    elseif GameState == "Creditos" then
        Creditos.draw()
    end

    PauseMenu.draw()
    if GameState == "Jogo" and Gameplay.player then
        PCMenu.draw(Gameplay.player)
    end
end

function music()
    BackgroundMusic = love.audio.newSource("assets/sounds/Background.mp3", "stream")

    BackgroundMusic:setLooping(true)
    BackgroundMusic:setVolume(0.5)
    BackgroundMusic:play()
end