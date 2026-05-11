local feikedex = require 'src/utils/Feikedex'
local SaveManager = require 'src/managers/SaveManager'

local BattleManager = {
    chance = 0.001,
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

    tipoBatalha = nil,
    trainer = nil,
    inimigoTime = nil,
    inimigoAtualIndex = nil,

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

function BattleManager.montaFeiKemon(id, level)
    level = level or 1
    local base = feikedex.feikemons[id]
    -- Escala stats pelo level (10% por nivel acima do 1)
    local scale = 1 + (level - 1) * 0.1
    local hp_max = math.floor(base.hp_max * scale)
    return {
        nome = base.nome,
        tipo = base.tipo,
        hp_max = hp_max,
        hp_atual = hp_max,
        ataques = base.ataques,
        foto_frente = base.foto_frente,
        foto_verso = base.foto_verso,
        level = level,
        xp = 0,
    }
end

function BattleManager.obterMelhorLevelEquipe(player)
    local maxLevel = 1
    for _, f in ipairs(player.equipe) do
        if f.level and f.level > maxLevel then
            maxLevel = f.level
        end
    end
    return maxLevel
end

function BattleManager.gerarLevelSelvagem(player)
    local melhorLevel = BattleManager.obterMelhorLevelEquipe(player)
    local minLevel = math.max(1, melhorLevel - 5)
    local maxLevel = melhorLevel + 10
    return math.random(minLevel, maxLevel)
end

function BattleManager.distribuirXp(xpBase, idVencedor)
    local xpParticipante = xpBase * 3
    local xpEquipe = xpBase

    for i, f in ipairs(BattleManager.player.equipe) do
        if f.hp_atual > 0 then
            local xpGanho = xpEquipe
            if i == idVencedor then
                xpGanho = xpParticipante
            end
            f.xp = f.xp + xpGanho
            BattleManager.addLog(f.nome .. " ganhou " .. xpGanho .. " XP!")
            BattleManager.tentarLevelUp(f)
        end
    end
end

function BattleManager.tentarLevelUp(feikemon)
    local xpNecessario = feikedex.xpParaUpar(feikemon.level)
    while feikemon.xp >= xpNecessario do
        feikemon.xp = feikemon.xp - xpNecessario
        feikemon.level = feikemon.level + 1
        -- Aumenta HP max em 10%
        local hpBonus = math.floor(feikemon.hp_max * 0.1)
        feikemon.hp_max = feikemon.hp_max + hpBonus
        -- Cura o HP bonus ganho
        feikemon.hp_atual = feikemon.hp_atual + hpBonus
        BattleManager.addLog(feikemon.nome .. " subiu para o level " .. feikemon.level .. "!")
        xpNecessario = feikedex.xpParaUpar(feikemon.level)
    end
end

function BattleManager.teleportarMacFEI()
    BattleManager.addLog("Todos os seus FeiKemons desmaiaram...")
    BattleManager.addLog("Voce foi levado ao MacFEI para recuperar!")
    BattleManager._teleportarAposDerrota = true
end

function BattleManager.check(dt, gameplay)
    if BattleManager.battleEnd then
        if not BattleManager.somAtivo:isPlaying() then
            -- Teleporta para MacFEI se necessario
            if BattleManager._teleportarAposDerrota then
                BattleManager._teleportarAposDerrota = nil
                local MapManager = require 'src/managers/MapManager'
                local porta = {
                    destino = "macfei",
                    x = 0,
                    y = 0,
                }
                MapManager.mudarMapa(porta, gameplay)
                -- Recupera todos os FeiKemons
                for _, f in ipairs(gameplay.player.equipe) do
                    f.hp_atual = f.hp_max
                end
            end

            BattleManager.battleEnd = false
            BattleManager.battleHappening = false
            BattleManager.somAtivo = nil
            BattleManager.menuAberto = "principal"
            BattleManager.tipoBatalha = nil
            BattleManager.trainer = nil
            BattleManager.inimigoTime = nil
            BattleManager.inimigoAtualIndex = nil
            GamePhase = "Gameplay"

            SaveManager.salvar(gameplay)
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
    local levelSelvagem = BattleManager.gerarLevelSelvagem(player)
    BattleManager.battleEnd = false
    GamePhase = "Battle"

    BattleManager.tipoBatalha = "selvagem"
    BattleManager.trainer = nil
    BattleManager.inimigoTime = nil
    BattleManager.inimigoAtualIndex = nil

    BattleManager.player = player
    BattleManager.logs = {"Um encontro selvagem! (Lv. " .. levelSelvagem .. ")"}

    BattleManager.inimigo = BattleManager.montaFeiKemon(randomID, levelSelvagem)
    BattleManager.imgInimigo = love.graphics.newImage(BattleManager.inimigo.foto_frente)

    BattleManager.id_feikemon = player:obterPrimeiroVivo()
    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
    if feikemon_player then
        BattleManager.imgPlayer = love.graphics.newImage(feikemon_player.foto_verso)
    end
end

function BattleManager.startTrainerBattle(player, trainer)
    love.audio.stop()

    BattleManager.sounds.musicaBatalha:setLooping(true)
    BattleManager.sounds.musicaBatalha:play()

    BattleManager.battleEnd = false
    GamePhase = "Battle"

    BattleManager.tipoBatalha = "treinador"
    BattleManager.trainer = trainer
    BattleManager.inimigoTime = {}
    for _, feikemon in ipairs(trainer.time) do
        table.insert(BattleManager.inimigoTime, {
            nome = feikemon.nome,
            tipo = feikemon.tipo,
            hp_max = feikemon.hp_max,
            hp_atual = feikemon.hp_atual,
            ataques = feikemon.ataques,
            foto_frente = feikemon.foto_frente,
            foto_verso = feikemon.foto_verso,
            level = feikemon.level or 1,
            xp = feikemon.xp or 0
        })
    end
    BattleManager.inimigoAtualIndex = 1

    BattleManager.player = player
    BattleManager.logs = {trainer.nome .. " desafiou voce para uma batalha!"}

    BattleManager.inimigo = BattleManager.inimigoTime[1]
    BattleManager.imgInimigo = love.graphics.newImage(BattleManager.inimigo.foto_frente)

    BattleManager.id_feikemon = player:obterPrimeiroVivo()
    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
    if feikemon_player then
        BattleManager.imgPlayer = love.graphics.newImage(feikemon_player.foto_verso)
    end
end

function BattleManager.controles(key)
    if BattleManager.battleEnd then return end

    if BattleManager.menuAberto == "principal" then
        if key == "1" then
            BattleManager.menuAberto = "golpes"
        elseif key == "2" then
            if BattleManager.tipoBatalha == "treinador" then
                BattleManager.addLog("Nao pode fugir de um treinador!")
            else
                BattleManager.addLog("Voce fugiu!")
                BattleManager.encerrarComSom("fuga")
            end
        elseif key == "3" then
            if BattleManager.tipoBatalha == "treinador" then
                BattleManager.addLog("Nao pode capturar FeiKemons de treinadores!")
            else
                local inimigo = BattleManager.inimigo
                local hpRatio = inimigo.hp_atual / inimigo.hp_max
                local chanceCaptura = math.max(0.1, 1.0 - hpRatio)

                if math.random() < chanceCaptura then
                    BattleManager.player:captura(inimigo)
                    BattleManager.addLog("Capturado com sucesso!")
                    -- Da XP pela captura (mesmo que derrotar)
                    local xpGanho = feikedex.calcularXpGanho(inimigo)
                    BattleManager.distribuirXp(xpGanho, BattleManager.id_feikemon)
                    BattleManager.encerrarComSom("captura")
                else
                    BattleManager.addLog("A Feikebola falhou! O " .. inimigo.nome .. " escapou!")
                    -- Turno do inimigo apos falha na captura
                    local atkInimigo = inimigo.ataques[math.random(1, #inimigo.ataques)]
                    local dadosAtkInimigo = feikedex.ataques[atkInimigo]
                    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
                    local danoCaptura, multCaptura = BattleManager.calcularDano(dadosAtkInimigo.dano, dadosAtkInimigo.tipo, feikemon_player.tipo, inimigo.level)
                    feikemon_player.hp_atual = math.max(0, feikemon_player.hp_atual - danoCaptura)
                    BattleManager.addLog("Inimigo usou " .. atkInimigo .. "!")
                    if multCaptura > 1 then
                        BattleManager.addLog("Foi super efetivo!")
                    elseif multCaptura < 1 then
                        BattleManager.addLog("Nao foi muito efetivo...")
                    end

                    if feikemon_player.hp_atual <= 0 then
                        local proximo = BattleManager.player:obterPrimeiroVivo()
                        if proximo then
                            BattleManager.id_feikemon = proximo
                            BattleManager.imgPlayer = love.graphics.newImage(BattleManager.player.equipe[proximo].foto_verso)
                            BattleManager.addLog("Vai, " .. BattleManager.player.equipe[proximo].nome .. "!")
                        else
                            BattleManager.addLog("Voce foi derrotado...")
                            BattleManager.teleportarMacFEI()
                            BattleManager.encerrarComSom("derrota")
                        end
                    end
                end
            end
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

function BattleManager.calcularDano(danoBase, tiposAtaque, tiposAlvo, levelAtacante)
    levelAtacante = levelAtacante or 1
    local multTipo = feikedex.calcularMultiplicador(tiposAtaque, tiposAlvo)
    -- Bonus de level: 5% por nivel acima do 1
    local multLevel = 1 + (levelAtacante - 1) * 0.05
    local danoTotal = math.floor(danoBase * multTipo * multLevel)
    return danoTotal, multTipo
end

function BattleManager.executarTurno(ataque)
    local feikemon_player = BattleManager.player.equipe[BattleManager.id_feikemon]
    local feikemon_enemy = BattleManager.inimigo

    -- Turno do Player
    local dadosAtaque = feikedex.ataques[ataque]
    local dano, mult = BattleManager.calcularDano(dadosAtaque.dano, dadosAtaque.tipo, feikemon_enemy.tipo, feikemon_player.level)
    feikemon_enemy.hp_atual = math.max(0, feikemon_enemy.hp_atual - dano)
    BattleManager.addLog(feikemon_player.nome .. " usou " .. ataque .. "!")
    if mult > 1 then
        BattleManager.addLog("Foi super efetivo!")
    elseif mult < 1 then
        BattleManager.addLog("Nao foi muito efetivo...")
    end

    if feikemon_enemy.hp_atual <= 0 then
        BattleManager.addLog(feikemon_enemy.nome .. " desmaiou!")

        -- Da XP para a equipe
        local xpGanho = feikedex.calcularXpGanho(feikemon_enemy)
        BattleManager.distribuirXp(xpGanho, BattleManager.id_feikemon)

        if BattleManager.tipoBatalha == "treinador" then
            BattleManager.inimigoAtualIndex = BattleManager.inimigoAtualIndex + 1
            if BattleManager.inimigoTime[BattleManager.inimigoAtualIndex] then
                BattleManager.inimigo = BattleManager.inimigoTime[BattleManager.inimigoAtualIndex]
                BattleManager.imgInimigo = love.graphics.newImage(BattleManager.inimigo.foto_frente)
                BattleManager.addLog(BattleManager.trainer.nome .. " enviou " .. BattleManager.inimigo.nome .. "!")
                return
            else
                BattleManager.addLog("Voce derrotou " .. BattleManager.trainer.nome .. "!")
                BattleManager.trainer.derrotado = true
                BattleManager.encerrarComSom("vitoria")
                return
            end
        else
            BattleManager.encerrarComSom("vitoria")
            return
        end
    end

    -- Turno do Inimigo
    local atkInimigo = feikemon_enemy.ataques[math.random(1, #feikemon_enemy.ataques)]
    local dadosAtkInimigo = feikedex.ataques[atkInimigo]
    local danoInimigo, multInimigo = BattleManager.calcularDano(dadosAtkInimigo.dano, dadosAtkInimigo.tipo, feikemon_player.tipo, feikemon_enemy.level)
    feikemon_player.hp_atual = math.max(0, feikemon_player.hp_atual - danoInimigo)
    BattleManager.addLog("Inimigo usou " .. atkInimigo .. "!")
    if multInimigo > 1 then
        BattleManager.addLog("Foi super efetivo!")
    elseif multInimigo < 1 then
        BattleManager.addLog("Nao foi muito efetivo...")
    end

    if feikemon_player.hp_atual <= 0 then
        local proximo = BattleManager.player:obterPrimeiroVivo()
        if proximo then
            BattleManager.id_feikemon = proximo
            BattleManager.imgPlayer = love.graphics.newImage(BattleManager.player.equipe[proximo].foto_verso)
            BattleManager.addLog("Vai, " .. BattleManager.player.equipe[proximo].nome .. "!")
        else
            BattleManager.addLog("Voce foi derrotado...")
            BattleManager.teleportarMacFEI()
            BattleManager.encerrarComSom("derrota")
        end
    end
end

function BattleManager.desenharBadgeTipo(tipo, x, y, escala)
    escala = escala or 1
    local cor = feikedex.obterCorTipo(tipo)
    local texto = tipo
    local largura = BattleManager.fonte:getWidth(texto) * escala + 10
    local altura = (BattleManager.fonte:getHeight() * escala) + 4

    love.graphics.setColor(cor[1] * 0.7, cor[2] * 0.7, cor[3] * 0.7)
    love.graphics.rectangle("fill", x, y, largura, altura, 3, 3)
    love.graphics.setColor(cor)
    love.graphics.rectangle("fill", x + 2, y + 2, largura - 4, altura - 4, 2, 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(texto, x + 5, y + 2, 0, escala, escala)

    return largura
end

function BattleManager.desenharBarraHp(hpAtual, hpMax, x, y, largura, altura)
    -- Fundo da barra
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", x, y, largura, altura)

    -- Cor baseada na porcentagem
    local pct = hpAtual / hpMax
    if pct > 0.5 then
        love.graphics.setColor(0.2, 0.8, 0.2)
    elseif pct > 0.2 then
        love.graphics.setColor(0.9, 0.9, 0.2)
    else
        love.graphics.setColor(0.9, 0.2, 0.2)
    end

    local fillW = math.max(0, largura * pct)
    love.graphics.rectangle("fill", x, y, fillW, altura)

    -- Borda
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("line", x, y, largura, altura)
end

function BattleManager.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local MARGIN = 15

    local pAtivo = BattleManager.player.equipe[BattleManager.id_feikemon]
    local eAtivo = BattleManager.inimigo

    -- 1. Fundo
    love.graphics.setColor(1, 1, 1)
    if BattleManager.imgFundo then
        local bgW, bgH = BattleManager.imgFundo:getDimensions()
        love.graphics.draw(BattleManager.imgFundo, 0, 0, 0, w / bgW, h / bgH)
    end

    -- 2. Quadros de Status
    love.graphics.setFont(BattleManager.fonte)

    -- Status do Player (Superior Esquerdo)
    local pStatusW, pStatusH = 300, 110
    local pStatusX, pStatusY = MARGIN, MARGIN
    love.graphics.setColor(BattleManager.corBorda)
    love.graphics.rectangle("fill", pStatusX, pStatusY, pStatusW, pStatusH)
    love.graphics.setColor(BattleManager.corFundo)
    love.graphics.rectangle("fill", pStatusX + 4, pStatusY + 4, pStatusW - 8, pStatusH - 8)
    love.graphics.setColor(BattleManager.corTexto)

    local pLevel = pAtivo.level or 1
    love.graphics.print(pAtivo.nome .. "  Lv." .. pLevel, pStatusX + 12, pStatusY + 10)
    love.graphics.print(pAtivo.hp_atual .. " / " .. pAtivo.hp_max, pStatusX + pStatusW - 100, pStatusY + 36)

    -- Barra de HP do Player
    BattleManager.desenharBarraHp(pAtivo.hp_atual, pAtivo.hp_max, pStatusX + 12, pStatusY + 36, pStatusW - 120, 18)

    -- Tipos do Player
    local tx = pStatusX + 12
    for _, tipo in ipairs(pAtivo.tipo) do
        tx = tx + BattleManager.desenharBadgeTipo(tipo, tx, pStatusY + 72, 0.8) + 6
    end

    -- Status do Inimigo (Superior Direito)
    local eStatusW, eStatusH = 300, 110
    local eStatusX, eStatusY = w - eStatusW - MARGIN, MARGIN
    love.graphics.setColor(BattleManager.corBorda)
    love.graphics.rectangle("fill", eStatusX, eStatusY, eStatusW, eStatusH)
    love.graphics.setColor(BattleManager.corFundo)
    love.graphics.rectangle("fill", eStatusX + 4, eStatusY + 4, eStatusW - 8, eStatusH - 8)
    love.graphics.setColor(BattleManager.corTexto)

    local eLevel = eAtivo.level or 1
    love.graphics.print(eAtivo.nome .. "  Lv." .. eLevel, eStatusX + 12, eStatusY + 10)
    love.graphics.print(eAtivo.hp_atual .. " / " .. eAtivo.hp_max, eStatusX + eStatusW - 100, eStatusY + 36)

    -- Barra de HP do Inimigo
    BattleManager.desenharBarraHp(eAtivo.hp_atual, eAtivo.hp_max, eStatusX + 12, eStatusY + 36, eStatusW - 120, 18)

    -- Tipos do Inimigo
    tx = eStatusX + 12
    for _, tipo in ipairs(eAtivo.tipo) do
        tx = tx + BattleManager.desenharBadgeTipo(tipo, tx, eStatusY + 72, 0.8) + 6
    end

    -- 3. Desenho dos FeiKemons
    local uiH = h * 0.28
    local uiY = h - uiH - MARGIN
    local portraitSize = uiH - 40
    local mult = 1.4

    love.graphics.setColor(1, 1, 1)
    if BattleManager.imgInimigo then
        local img = BattleManager.imgInimigo
        local s = (portraitSize / img:getWidth()) * mult
        love.graphics.draw(img, w - (img:getWidth() * s) - MARGIN - 300, MARGIN + 130, 0, s, s)
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
            love.graphics.print("3. CAPTURAR", menuX, uiY + 90)
        elseif BattleManager.menuAberto == "golpes" then
            for i, atk in ipairs(pAtivo.ataques) do
                if i <= 4 then
                    local dadosAtk = feikedex.ataques[atk]
                    local multPreview = feikedex.calcularMultiplicador(dadosAtk.tipo, eAtivo.tipo)
                    local multTexto = ""
                    if multPreview > 1 then multTexto = " (2x)" end
                    if multPreview < 1 then multTexto = " (0.5x)" end

                    local linhaY = uiY + 18 + (i-1)*32
                    love.graphics.print(i .. ". " .. atk .. multTexto, menuX, linhaY)

                    -- Desenha badge do tipo do ataque
                    local textoLargura = BattleManager.fonte:getWidth(i .. ". " .. atk .. multTexto)
                    local badgeX = menuX + textoLargura + 10
                    for _, tipoAtk in ipairs(dadosAtk.tipo) do
                        badgeX = badgeX + BattleManager.desenharBadgeTipo(tipoAtk, badgeX, linhaY, 0.7) + 4
                    end
                end
            end
            love.graphics.print("5. VOLTAR", menuX, uiY + uiH - 35)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

return BattleManager