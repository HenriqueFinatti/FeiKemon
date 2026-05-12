---@diagnostic disable: undefined-global
local camera = require 'src/libs/camera'
local Player = require 'src/entities/Player'
local Onboarding = require 'src/scenes/Onboarding'
local Transition = require 'src/utils/Transition'
local BattleManager = require 'src/managers/BattleManager'
local MapManager = require 'src/managers/MapManager'
local TeamMenu = require 'src/ui/TeamMenu'
local PCMenu = require 'src/ui/PCMenu'

Gameplay = {}

local VIRTUAL_WIDTH = 512
local VIRTUAL_HEIGHT = 216

GamePhase = "Onboarding"

function Gameplay.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Gameplay.loadCamera()
    Gameplay.onboarding = Onboarding()

    Gameplay.leilaDerrotada = false
    Gameplay.posJogo = false
    Gameplay._creditosExibidos = false

    local inicial = BattleManager.montaFeiKemon(1)
    local portaInicial = {
        destino = "sala de estudos",
        x = -16,
        y = 165
    }

    Gameplay.player = Player()
    Gameplay.player:captura(inicial)
    MapManager.mudarMapa(portaInicial, Gameplay)
end

function Gameplay.loadFromSave()
    love.graphics.setDefaultFilter("nearest", "nearest")
    Gameplay.loadCamera()
    Gameplay.onboarding = Onboarding()

    Gameplay.leilaDerrotada = false
    Gameplay.posJogo = false
    Gameplay._creditosExibidos = false

    local SaveManager = require 'src/managers/SaveManager'
    if SaveManager.existeSave() then
        Gameplay.player = Player()
        local ok = SaveManager.carregar(Gameplay)
        if ok then
            return true
        end
    end

    -- Fallback: novo jogo se nao houver save
    local inicial = BattleManager.montaFeiKemon(1)
    local portaInicial = {
        destino = "sala de estudos",
        x = -16,
        y = 165
    }

    Gameplay.player = Player()
    Gameplay.player:captura(inicial)
    MapManager.mudarMapa(portaInicial, Gameplay)
    return false
end

function Gameplay.update(dt)
    Transition.update(dt)

    if GamePhase == "Onboarding" then
        Gameplay.onboarding:update(dt)

    elseif GamePhase == "Gameplay" or GamePhase == "Dialogo" or GamePhase == "Pause" then
        if GamePhase ~= "Pause" then
            World:update(dt)
        end

        if Gameplay.mapaAtual and Gameplay.mapaAtual.update and GamePhase ~= "Pause" then
            Gameplay.mapaAtual:update(dt)
        end

        if GamePhase == "Gameplay" and not PCMenu.isVisible() then
            local collider = Gameplay.player.collider
            if Transition.state == "none" and collider:enter('Portas') then
                local porta = collider:getEnterCollisionData('Portas').collider
                Transition.start(3, function() MapManager.mudarMapa(porta, Gameplay) end)
            end

            Gameplay.player:update(dt)
            Cam:lookAt(Gameplay.player.x, Gameplay.player.y)
        end
    end
    BattleManager.check(dt, Gameplay)

    if GamePhase == "Dialogo" then
        TextBoxManagerGlobal:update(dt)
    end
end

function Gameplay.draw()
    love.graphics.clear()
    if GamePhase == "Battle" then
        -- Se estiver em batalha, desenha apenas a UI da batalha ocupando tudo
        BattleManager.draw()
    else
        -- Desenho normal do mapa e player
        Cam:attach()
            love.graphics.setColor(1,1,1,1)
            if GamePhase == "Onboarding" then
                Gameplay.onboarding:draw()
            else
                if Gameplay.mapaAtual then Gameplay.mapaAtual:draw() end
                if Gameplay.player then Gameplay.player:draw() end
            end

            if GamePhase == "Dialogo" then
                TextBoxManagerGlobal:draw()
            end
        Cam:detach()

        if GamePhase == "Gameplay" or GamePhase == "Dialogo" then
            TeamMenu.draw(Gameplay.player.equipe)
        end
    end

    Transition.draw()
end

function Gameplay.treinadorAnteriorDerrotado(trainer)
    if trainer.ordem <= 1 then return true end
    for _, t in ipairs(Gameplay.mapaAtual.trainers) do
        if t.ordem == trainer.ordem - 1 then
            return t.derrotado
        end
    end
    return true
end

function Gameplay.tentarInteragir()
    if GamePhase ~= "Gameplay" then return end
    if not Gameplay.mapaAtual or not Gameplay.mapaAtual.trainers then return end

    for _, trainer in ipairs(Gameplay.mapaAtual.trainers) do
        if trainer:estaPerto(Gameplay.player.x, Gameplay.player.y) then
            -- Fecha menu se estiver aberto
            if TeamMenu.isVisible then
                TeamMenu.toggle()
            end

            -- NPCs so conversam
            if trainer.isNpc then
                GamePhase = "Dialogo"
                TextBoxManagerGlobal:setFalas(trainer.falasPre, #trainer.falasPre, trainer.onComplete)
                TextBoxManagerGlobal.dialogoAtivo = true
                return
            end

            if trainer.derrotado then
                -- Modo pos-jogo: oferece revanche
                if Gameplay.posJogo and not trainer.isNpc then
                    GamePhase = "Dialogo"
                    TextBoxManagerGlobal:setFalas({
                        {nome=trainer.nome, texto="Quer uma revanche? Desta vez meus FeiKemons estarao no seu nivel!", retrato=trainer.retrato}
                    }, 1, function()
                        local melhorLevel = BattleManager.obterMelhorLevelEquipe(Gameplay.player)
                        trainer:rebuildTime(melhorLevel)
                        BattleManager.startTrainerBattle(Gameplay.player, trainer)
                    end)
                    TextBoxManagerGlobal.dialogoAtivo = true
                elseif trainer.falasPos and #trainer.falasPos > 0 then
                    GamePhase = "Dialogo"
                    TextBoxManagerGlobal:setFalas(trainer.falasPos, #trainer.falasPos)
                    TextBoxManagerGlobal.dialogoAtivo = true
                end
            else
                -- Verifica progressao
                if not Gameplay.treinadorAnteriorDerrotado(trainer) then
                    GamePhase = "Dialogo"
                    TextBoxManagerGlobal:setFalas({
                        {nome=trainer.nome, texto="Voce ainda nao esta pronto para me enfrentar. Derrote os outros professores primeiro!", retrato=trainer.retrato}
                    }, 1)
                    TextBoxManagerGlobal.dialogoAtivo = true
                    return
                end

                -- Verifica se o jogador tem FeiKemons vivos
                if not Gameplay.player:obterPrimeiroVivo() then
                    GamePhase = "Dialogo"
                    TextBoxManagerGlobal:setFalas({
                        {nome=trainer.nome, texto="Voce nao tem FeiKemons em condicoes de batalhar! Va ao MacFEI recupera-los.", retrato=trainer.retrato}
                    }, 1)
                    TextBoxManagerGlobal.dialogoAtivo = true
                    return
                end

                GamePhase = "Dialogo"
                TextBoxManagerGlobal:setFalas(trainer.falasPre, #trainer.falasPre, function()
                    BattleManager.startTrainerBattle(Gameplay.player, trainer)
                end)
                TextBoxManagerGlobal.dialogoAtivo = true
            end
            return
        end
    end
end

function Gameplay.loadCamera()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    local escala = math.min(sw / VIRTUAL_WIDTH, sh / VIRTUAL_HEIGHT)

    Cam = camera()
    Cam:zoomTo(escala + 2.5)
end

return Gameplay