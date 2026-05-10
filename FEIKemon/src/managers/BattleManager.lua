local feikedex = require 'src/utils/Feikedex'
local TeamMenu = require 'src/ui/TeamMenu'

local BattleManager = {
    chance = 0.05,
    inimigo = nil,
    playerRef = nil,
    menuAberto = "principal",
    indiceAtivo = 1,

    logs = {"Uma batalha iniciou!"},
    imgInimigo = nil,
    imgPlayer = nil,
    fonte = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18),

    -- Estilização (Igual ao TeamMenu)
    corFundo = {0.7, 0.55, 0.4},
    corBorda = {0.4, 0.23, 0.12},
    corTexto = {0.2, 0.1, 0.05}
}

function BattleManager.addLog(msg)
    table.insert(BattleManager.logs, msg)
    if #BattleManager.logs > 6 then table.remove(BattleManager.logs, 1) end
end

function BattleManager.montaFeiKemon(id)
    local base = feikedex.feikemons[id]
    if not base then return nil end
    return {
        nome = base.nome, tipo = base.tipo, hp_max = base.hp_max,
        hp_atual = base.hp_max, ataques = base.ataques,
        foto_frente = base.foto_frente, foto_verso = base.foto_verso
    }
end

function BattleManager.check(dt, gameplay)
    if GamePhase ~= "Gameplay" then return end

    if gameplay.mapaAtual.name == "area externa" then
        local vx, vy = gameplay.player.collider:getLinearVelocity()
        if math.abs(vx) > 0 or math.abs(vy) > 0 then
            if math.random() < BattleManager.chance then
                if gameplay.player:obterPrimeiroVivo() then
                    BattleManager.startBattle(gameplay.player)
                end
            end
        end
    end
end

function BattleManager.startBattle(player)
    GamePhase = "Battle"
    BattleManager.playerRef = player
    BattleManager.indiceAtivo = player:obterPrimeiroVivo()
    BattleManager.logs = {"Um encontro selvagem!"}

    local randomID = math.random(1, #feikedex.feikemons)

    BattleManager.inimigo = BattleManager.montaFeiKemon(randomID)
    BattleManager.imgInimigo = love.graphics.newImage(BattleManager.inimigo.foto_frente)

    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    BattleManager.imgPlayer = love.graphics.newImage(pFeikemon.foto_verso)
end

function BattleManager.exibirMenuPrincipal()
    BattleManager.menuAberto = "principal"
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    print("\nO que " .. pFeikemon.nome .. " deve fazer?")
    print("1. Lutar | 2. Fugir | 3. Aprender")
    print("==========================================")
end

function BattleManager.exibirMenuGolpes()
    BattleManager.menuAberto = "golpes"
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    print("\nGolpes de " .. pFeikemon.nome .. ":")
    for i, nomeAtaque in ipairs(pFeikemon.ataques) do
        print(i .. ". " .. nomeAtaque)
    end
    print("5. Voltar")
end

function BattleManager.controles(key)
    if BattleManager.menuAberto == "principal" then
        if key == "1" then
            BattleManager.exibirMenuGolpes()
        elseif key == "2" then
            print("Você fugiu!")
            GamePhase = "Gameplay"
        elseif key == "3" then
            BattleManager.playerRef:captura(BattleManager.inimigo)
            GamePhase = "Gameplay"
        end
    elseif BattleManager.menuAberto == "golpes" then
        local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
        local num = tonumber(key)
        if num and num >= 1 and num <= #pFeikemon.ataques then
            BattleManager.executarTurno(pFeikemon.ataques[num])
        elseif key == "5" then
            BattleManager.exibirMenuPrincipal()
        end
    end
end

function BattleManager.executarTurno(ataqueNome)
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    local eFeikemon = BattleManager.inimigo

    -- Player ataca
    local dadosAtaque = feikedex.ataques[ataqueNome]
    eFeikemon.hp_atual = math.max(0, eFeikemon.hp_atual - dadosAtaque.dano)
    BattleManager.addLog(pFeikemon.nome .. " usou " .. ataqueNome .. "!")

    if eFeikemon.hp_atual <= 0 then
        BattleManager.addLog(eFeikemon.nome .. " desmaiou!")
        GamePhase = "Gameplay"
        return
    end

    -- Inimigo ataca
    local atkInimigo = eFeikemon.ataques[math.random(1, #eFeikemon.ataques)]
    local dadosAtkInimigo = feikedex.ataques[atkInimigo]
    pFeikemon.hp_atual = math.max(0, pFeikemon.hp_atual - dadosAtkInimigo.dano)
    BattleManager.addLog("Inimigo usou " .. atkInimigo .. "!")

    if pFeikemon.hp_atual <= 0 then
        local proximo = BattleManager.playerRef:obterPrimeiroVivo()
        if proximo then
            BattleManager.indiceAtivo = proximo
            BattleManager.imgPlayer = love.graphics.newImage(BattleManager.playerRef.equipe[proximo].foto_verso)
            BattleManager.addLog("Vai, " .. BattleManager.playerRef.equipe[proximo].nome .. "!")
        else
            GamePhase = "Gameplay"
        end
    end
end

function BattleManager.draw()
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    -- 1. Definições de Dimensões (Baseadas no seu TextBoxManager)
    local MARGIN = 15
    local uiH = h * 0.28
    local uiW = w - (MARGIN * 2)
    local uiX = MARGIN
    local uiY = h - uiH - MARGIN

    -- Tamanho da "moldura" do FeiKemon baseado na altura da UI
    local portraitSize = uiH - (20 * 2) -- padding de 20

    -- 2. Fundo da Arena
    love.graphics.setColor(0.3, 0.3, 0.3) -- Cinza
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- 3. Desenho dos FeiKemons (Nítidos e Posicionados)
    love.graphics.setColor(1, 1, 1)

    -- INIMIGO: Canto superior direito da tela
    -- Ajuste este valor para controlar o tamanho (1.0 = tamanho original da UI, 1.5 = 50% maior)
    local multiplicadorVisual = 1.4

    -- INIMIGO: Canto superior direito
    if BattleManager.imgInimigo then
        local img = BattleManager.imgInimigo
        -- Calculamos a escala base e aplicamos o multiplicador
        local scaleE = (portraitSize / img:getWidth()) * multiplicadorVisual

        -- Ajustamos a posição X para que ele não saia da tela ao crescer
        local enemyX = w - (img:getWidth() * scaleE) - MARGIN
        local enemyY = MARGIN + 10

        love.graphics.draw(img, enemyX, enemyY, 0, scaleE, scaleE)
    end

    -- PLAYER: Acima da metade esquerda
    if BattleManager.imgPlayer then
        local img = BattleManager.imgPlayer
        local scaleP = (portraitSize / img:getWidth()) * multiplicadorVisual

        local playerX = uiX + 20
        -- Subtraímos o tamanho real da imagem escalada para ele flutuar perfeitamente
        local playerY = uiY - (img:getHeight() * scaleP) - 10

        love.graphics.draw(img, playerX, playerY, 0, scaleP, scaleP)
    end

    -- 4. UI de Batalha (Estilo rústico)
    -- Borda (Marrom Escuro)
    love.graphics.setColor(BattleManager.corBorda)
    love.graphics.rectangle("fill", uiX, uiY, uiW, uiH)

    -- Fundo (Marrom Claro)
    love.graphics.setColor(BattleManager.corFundo)
    local bSize = 6 -- Espessura da borda
    love.graphics.rectangle("fill", uiX + bSize, uiY + bSize, uiW - (bSize * 2), uiH - (bSize * 2))

    -- 5. Conteúdo da UI
    love.graphics.setFont(BattleManager.fonte)
    love.graphics.setColor(BattleManager.corTexto)

    -- Divisória Central
    local meiaTela = uiX + (uiW / 2)
    love.graphics.line(meiaTela, uiY + 10, meiaTela, uiY + uiH - 10)

    -- METADE ESQUERDA: Logs de Batalha
    local logX = uiX + 20
    for i, log in ipairs(BattleManager.logs) do
        love.graphics.print(log, logX, uiY + 15 + (i-1)*22)
    end

    -- METADE DIREITA: Menu de Ações
    local menuX = meiaTela + 30
    if BattleManager.menuAberto == "principal" then
        love.graphics.print("1. LUTAR", menuX, uiY + 30)
        love.graphics.print("2. FUGIR", menuX, uiY + 60)
        love.graphics.print("3. APRENDER", menuX, uiY + 90)
    elseif BattleManager.menuAberto == "golpes" then
        local pAtivo = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
        for i, atk in ipairs(pAtivo.ataques) do
            if i <= 4 then -- Garante que não quebre o layout
                love.graphics.print(i .. ". " .. atk, menuX, uiY + 20 + (i-1)*25)
            end
        end
        love.graphics.print("5. VOLTAR", menuX, uiY + uiH - 35)
    end

    love.graphics.setColor(1, 1, 1) -- Reset final
end

return BattleManager