local feikedex = require 'src/utils/Feikedex'

local BattleManager = {
    chance = 0.005,
    inimigo = nil,
    player = nil,
    menuAberto = "principal",
    id_feikemon = 1,

    logs = nil,
    imgInimigo = nil,
    imgPlayer = nil,

    fonte = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18),
    imgFundo = love.graphics.newImage("assets/images/BackgroundBatalha.png"),

    corFundo = {0.7, 0.55, 0.4},
    corBorda = {0.4, 0.23, 0.12},
    corTexto = {0.2, 0.1, 0.05},

    battleEnd = false,
    battleHappening = false,
    somAtivo = nil,
    sounds = {
        vitoria = love.audio.newSource("assets/sounds/vitoria.mp3", "static"),
        derrota = love.audio.newSource("assets/sounds/derrota.mp3", "static"),
        captura = love.audio.newSource("assets/sounds/captura.mp3", "static"),
        fuga    = love.audio.newSource("assets/sounds/fuga.mp3", "static"),
        musicaBatalha = love.audio.newSource("assets/sounds/backgroundBatalha.mp3", "stream")
    }
}

function BattleManager.encerrarComSom(tipoSom)
    BattleManager.sounds.musicaBatalha:stop()

    BattleManager.battleEnd = true
    BattleManager.somAtivo = BattleManager.sounds[tipoSom]
    BattleManager.somAtivo:play()
end

function BattleManager.addLog(msg)
    table.insert(BattleManager.logs, msg)
    if #BattleManager.logs > 6 then table.remove(BattleManager.logs, 1) end
end

function BattleManager.montaFeiKemon(id)
    local base = feikedex.feikemons[id]
    return {
        nome = base.nome,
        tipo = base.tipo,
        hp_max = base.hp_max,
        hp_atual = base.hp_max,
        ataques = base.ataques,
        foto_frente = base.foto_frente,
        foto_verso = base.foto_verso
    }
end

function BattleManager.check(dt, gameplay)
    if BattleManager.battleEnd then
        if not BattleManager.somAtivo:isPlaying() then
            BattleManager.battleEnd = false
            BattleManager.battleHappening = false
            BattleManager.somAtivo = nil
            BattleManager.menuAberto = "principal"
            GamePhase = "Gameplay"

            BackgroundMusic:play()
        end
        return
    end

    if gameplay.mapaAtual.name == "area externa" and not BattleManager.battleHappening then
        local vx, vy = gameplay.player.collider:getLinearVelocity()
        if math.abs(vx) > 0 or math.abs(vy) > 0 then
            if math.random() < BattleManager.chance then
                if gameplay.player:obterPrimeiroVivo() then
                    BattleManager.battleHappening = true
                    BattleManager.startBattle(gameplay.player)
                end
            end
        end
    end
end

function BattleManager.startBattle(player)
    love.audio.stop()

    BattleManager.sounds.musicaBatalha:setLooping(true)
    BattleManager.sounds.musicaBatalha:play()

    local randomID = math.random(1, #feikedex.feikemons)
    BattleManager.battleEnd = false
    GamePhase = "Battle"

    BattleManager.player = player
    BattleManager.logs = {"Um encontro selvagem!"}

    BattleManager.inimigo = BattleManager.montaFeiKemon(randomID)
    BattleManager.imgInimigo = love.graphics.newImage(BattleManager.inimigo.foto_frente)

    BattleManager.id_feikemon = player:obterPrimeiroVivo()
    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
    BattleManager.imgPlayer = love.graphics.newImage(feikemon_player.foto_verso)
end

function BattleManager.controles(key)
    if BattleManager.battleEnd then return end

    if BattleManager.menuAberto == "principal" then
        if key == "1" then
            BattleManager.menuAberto = "golpes"
        elseif key == "2" then
            BattleManager.addLog("Você fugiu!")
            BattleManager.encerrarComSom("fuga")
        elseif key == "3" then
            BattleManager.player:captura(BattleManager.inimigo)
            BattleManager.addLog("Capturado com sucesso!")
            BattleManager.encerrarComSom("captura")
        end
    elseif BattleManager.menuAberto == "golpes" then
        local num = tonumber(key)
        local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]

        if num and num >= 1 and num <= #feikemon_player.ataques then
            BattleManager.executarTurno(feikemon_player.ataques[num])
        elseif key == "5" then
            BattleManager.menuAberto = "principal"
        end
    end
end

function BattleManager.executarTurno(ataque)
    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
    local feikemon_enemy = BattleManager.inimigo

    -- Turno do Player
    local dadosAtaque = feikedex.ataques[ataque]
    feikemon_enemy.hp_atual = math.max(0, feikemon_enemy.hp_atual - dadosAtaque.dano)
    BattleManager.addLog(feikemon_player.nome .. " usou " .. ataque .. "!")

    if feikemon_enemy.hp_atual <= 0 then
        BattleManager.addLog(feikemon_enemy.nome .. " desmaiou!")
        BattleManager.encerrarComSom("vitoria")
        return
    end

    -- Turno do Inimigo
    local atkInimigo = feikemon_enemy.ataques[math.random(1, #feikemon_enemy.ataques)]
    local dadosAtkInimigo = feikedex.ataques[atkInimigo]
    feikemon_player.hp_atual = math.max(0, feikemon_player.hp_atual - dadosAtkInimigo.dano)
    BattleManager.addLog("Inimigo usou " .. atkInimigo .. "!")

    if feikemon_player.hp_atual <= 0 then
        local proximo = BattleManager.player:obterPrimeiroVivo()
        if proximo then
            BattleManager.id_feikemon = proximo
            BattleManager.imgPlayer = love.graphics.newImage(BattleManager.player.equipe[proximo].foto_verso)
            BattleManager.addLog("Vai, " .. BattleManager.player.equipe[proximo].nome .. "!")
        else
            BattleManager.addLog("Você foi derrotado...")
            BattleManager.encerrarComSom("derrota")
        end
    end
end

function BattleManager.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local MARGIN = 15

    -- 1. Fundo
    love.graphics.setColor(1, 1, 1)
    if BattleManager.imgFundo then
        local bgW, bgH = BattleManager.imgFundo:getDimensions()
        love.graphics.draw(BattleManager.imgFundo, 0, 0, 0, w / bgW, h / bgH)
    end

    -- 2. Quadro de Status (Vida) - Superior Esquerdo
    local statusW, statusH = 300, 100
    local statusX, statusY = MARGIN, MARGIN

    -- Desenho do Quadro de Status
    love.graphics.setColor(BattleManager.corBorda)
    love.graphics.rectangle("fill", statusX, statusY, statusW, statusH)
    love.graphics.setColor(BattleManager.corFundo)
    love.graphics.rectangle("fill", statusX + 4, statusY + 4, statusW - 8, statusH - 8)

    love.graphics.setFont(BattleManager.fonte)
    love.graphics.setColor(BattleManager.corTexto)

    local pAtivo = BattleManager.player.equipe[BattleManager.id_feikemon]
    local eAtivo = BattleManager.inimigo

    -- Texto da Vida
    love.graphics.print(pAtivo.nome .. ". HP: " .. pAtivo.hp_atual .. "/" .. pAtivo.hp_max, statusX + 15, statusY + 15)
    love.graphics.print(eAtivo.nome .. ". HP: " .. eAtivo.hp_atual .. "/" .. eAtivo.hp_max, statusX + 15, statusY + 55)

    -- 3. Desenho dos FeiKemons
    local uiH = h * 0.28
    local uiY = h - uiH - MARGIN
    local portraitSize = uiH - 40
    local mult = 1.4

    love.graphics.setColor(1, 1, 1)
    if BattleManager.imgInimigo then
        local img = BattleManager.imgInimigo
        local s = (portraitSize / img:getWidth()) * mult
        love.graphics.draw(img, w - (img:getWidth() * s) - MARGIN - 300, MARGIN + 10, 0, s, s)
    end

    if BattleManager.imgPlayer then
        local img = BattleManager.imgPlayer
        local s = (portraitSize / img:getWidth()) * mult
        love.graphics.draw(img, MARGIN + 180, uiY - (img:getHeight() * s) + 130, 0, s, s)
    end

    -- 4. UI de Batalha (Inferior)
    local uiW, uiX = w - (MARGIN * 2), MARGIN
    love.graphics.setColor(BattleManager.corBorda)
    love.graphics.rectangle("fill", uiX, uiY, uiW, uiH)
    love.graphics.setColor(BattleManager.corFundo)
    love.graphics.rectangle("fill", uiX + 6, uiY + 6, uiW - 12, uiH - 12)

    love.graphics.setColor(BattleManager.corTexto)
    local meiaTela = uiX + (uiW / 2)
    love.graphics.line(meiaTela, uiY + 10, meiaTela, uiY + uiH - 10)

    -- Logs
    for i, log in ipairs(BattleManager.logs) do
        love.graphics.print(log, uiX + 20, uiY + 15 + (i-1)*22)
    end

    -- Menu
    if not BattleManager.battleEnd then
        local menuX = meiaTela + 30
        if BattleManager.menuAberto == "principal" then
            love.graphics.print("1. LUTAR", menuX, uiY + 30)
            love.graphics.print("2. FUGIR", menuX, uiY + 60)
            love.graphics.print("3. APRENDER", menuX, uiY + 90)
        elseif BattleManager.menuAberto == "golpes" then
            for i, atk in ipairs(pAtivo.ataques) do
                if i <= 4 then love.graphics.print(i .. ". " .. atk, menuX, uiY + 20 + (i-1)*25) end
            end
            love.graphics.print("5. VOLTAR", menuX, uiY + uiH - 35)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

return BattleManager