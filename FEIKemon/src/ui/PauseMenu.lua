local SaveManager = require 'src/managers/SaveManager'

local PauseMenu = {
    ativo = false,
    selecao = 1,
    opcoes = {"Continuar", "Salvar Jogo", "Carregar Jogo", "Volume: ", "Sair do Jogo"},
    volume = 0.5,
    mensagem = nil,
    mensagemTimer = 0,

    fonte = nil,
    fonteSmall = nil,
    corFundo = {0, 0, 0, 0.7},
    corPainel = {0.15, 0.1, 0.05, 0.95},
    corTexto = {0.9, 0.85, 0.75},
    corSelecao = {1.0, 0.7, 0.3},
    corSucesso = {0.4, 1.0, 0.4},
    corErro = {1.0, 0.3, 0.3},
}

function PauseMenu.load()
    PauseMenu.fonte = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 32)
    PauseMenu.fonteSmall = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20)
    PauseMenu.volume = love.audio.getVolume() or 0.5
end

function PauseMenu.toggle()
    PauseMenu.ativo = not PauseMenu.ativo
    PauseMenu.selecao = 1
    if PauseMenu.ativo then
        GamePhaseAnterior = GamePhase
        GamePhase = "Pause"
    else
        GamePhase = GamePhaseAnterior or "Gameplay"
    end
end

function PauseMenu.controles(key)
    if not PauseMenu.ativo then return end

    if key == "w" or key == "up" then
        PauseMenu.selecao = PauseMenu.selecao - 1
        if PauseMenu.selecao < 1 then PauseMenu.selecao = #PauseMenu.opcoes end
    elseif key == "s" or key == "down" then
        PauseMenu.selecao = PauseMenu.selecao + 1
        if PauseMenu.selecao > #PauseMenu.opcoes then PauseMenu.selecao = 1 end
    elseif key == "return" or key == "space" then
        if PauseMenu.selecao == 1 then
            PauseMenu.toggle()
        elseif PauseMenu.selecao == 2 then
            if Gameplay then
                local ok, err = SaveManager.salvar(Gameplay)
                if ok then
                    PauseMenu.mostrarMensagem("Jogo salvo com sucesso!", true)
                else
                    PauseMenu.mostrarMensagem("Erro: " .. (err or "desconhecido"), false)
                end
            else
                PauseMenu.mostrarMensagem("Erro: Gameplay nao encontrado", false)
            end
        elseif PauseMenu.selecao == 3 then
            if Gameplay then
                local ok, err = SaveManager.carregar(Gameplay)
                if ok then
                    PauseMenu.mostrarMensagem("Jogo carregado! Fechando menu...", true)
                    -- Fecha o menu de pausa automaticamente apos 1 segundo
                    PauseMenu._autoCloseTimer = 1
                else
                    PauseMenu.mostrarMensagem("Erro: " .. (err or "Nenhum save encontrado"), false)
                end
            else
                PauseMenu.mostrarMensagem("Erro: Gameplay nao encontrado", false)
            end
        elseif PauseMenu.selecao == 4 then
            -- altera volume em passos de 0.1
            PauseMenu.volume = PauseMenu.volume + 0.1
            if PauseMenu.volume > 1.0 then PauseMenu.volume = 0.0 end
            love.audio.setVolume(PauseMenu.volume)
            if BackgroundMusic then
                BackgroundMusic:setVolume(PauseMenu.volume)
            end
        elseif PauseMenu.selecao == 5 then
            love.event.quit()
        end
    elseif key == "a" or key == "left" then
        if PauseMenu.selecao == 4 then
            PauseMenu.volume = math.max(0.0, PauseMenu.volume - 0.1)
            love.audio.setVolume(PauseMenu.volume)
            if BackgroundMusic then
                BackgroundMusic:setVolume(PauseMenu.volume)
            end
        end
    elseif key == "d" or key == "right" then
        if PauseMenu.selecao == 4 then
            PauseMenu.volume = math.min(1.0, PauseMenu.volume + 0.1)
            love.audio.setVolume(PauseMenu.volume)
            if BackgroundMusic then
                BackgroundMusic:setVolume(PauseMenu.volume)
            end
        end
    end
end

function PauseMenu.mostrarMensagem(texto, sucesso)
    PauseMenu.mensagem = texto
    PauseMenu.mensagemSucesso = sucesso
    PauseMenu.mensagemTimer = 3
end

function PauseMenu.update(dt)
    if PauseMenu.mensagemTimer > 0 then
        PauseMenu.mensagemTimer = PauseMenu.mensagemTimer - dt
        if PauseMenu.mensagemTimer <= 0 then
            PauseMenu.mensagem = nil
        end
    end
    if PauseMenu._autoCloseTimer then
        PauseMenu._autoCloseTimer = PauseMenu._autoCloseTimer - dt
        if PauseMenu._autoCloseTimer <= 0 then
            PauseMenu._autoCloseTimer = nil
            PauseMenu.toggle()
        end
    end
end

function PauseMenu.draw()
    if not PauseMenu.ativo then return end

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()

    love.graphics.setColor(PauseMenu.corFundo)
    love.graphics.rectangle("fill", 0, 0, w, h)

    local pw, ph = 500, 420
    local px, py = (w - pw) / 2, (h - ph) / 2

    love.graphics.setColor(PauseMenu.corPainel)
    love.graphics.rectangle("fill", px, py, pw, ph, 8, 8)

    love.graphics.setColor(PauseMenu.corTexto)
    love.graphics.setFont(PauseMenu.fonte)
    love.graphics.printf("PAUSA", px, py + 30, pw, "center")

    local itemH = 55
    local startY = py + 90
    for i, opcao in ipairs(PauseMenu.opcoes) do
        local texto = opcao
        if i == 4 then
            texto = opcao .. math.floor(PauseMenu.volume * 100) .. "%"
        end

        if i == PauseMenu.selecao then
            love.graphics.setColor(PauseMenu.corSelecao)
            love.graphics.rectangle("fill", px + 40, startY + (i-1)*itemH - 8, pw - 80, 44, 4, 4)
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(PauseMenu.corTexto)
        end
        love.graphics.printf(texto, px, startY + (i-1)*itemH, pw, "center")
    end

    -- Mensagem de feedback
    if PauseMenu.mensagem then
        love.graphics.setFont(PauseMenu.fonteSmall)
        if PauseMenu.mensagemSucesso then
            love.graphics.setColor(PauseMenu.corSucesso)
        else
            love.graphics.setColor(PauseMenu.corErro)
        end
        love.graphics.printf(PauseMenu.mensagem, px, py + ph - 50, pw, "center")
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return PauseMenu
