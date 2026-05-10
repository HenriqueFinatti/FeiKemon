local TeamMenu = {
    isVisible = false,
    width = 200,
    font = nil,
    -- Cores
    corFundo = {0.7, 0.55, 0.4},      -- Marrom Claro
    corBorda = {0.4, 0.23, 0.12},     -- Marrom Escuro (Madeira)
    corTexto = {0.2, 0.1, 0.05}       -- Marrom quase preto
}

function TeamMenu.load()
    -- Carregando a fonte conforme os requisitos
    TeamMenu.font = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18)
end

function TeamMenu.toggle()
    TeamMenu.isVisible = not TeamMenu.isVisible
end

function TeamMenu.draw(equipe)
    if not TeamMenu.isVisible then return end

    local h = love.graphics.getHeight()
    local w = TeamMenu.width

    -- 1. Desenhar a Borda (Estilo madeira rústica)
    love.graphics.setColor(TeamMenu.corBorda)
    love.graphics.rectangle("fill", 0, 0, w, h)

    -- 2. Desenhar o Fundo (Recuado para criar a borda)
    love.graphics.setColor(TeamMenu.corFundo)
    local borderSize = 8
    love.graphics.rectangle("fill", borderSize, borderSize, w - (borderSize * 2), h - (borderSize * 2))

    -- 3. Configurar Texto
    love.graphics.setFont(TeamMenu.font)
    love.graphics.setColor(TeamMenu.corTexto)

    love.graphics.print("SUA EQUIPE", 25, 25)
    love.graphics.line(20, 50, w - 20, 50) -- Linha decorativa

    -- 4. Listar FeiKemons
    local paddingY = 70
    for i, feikemon in ipairs(equipe) do
        local yPos = paddingY + (i - 1) * 30
        love.graphics.print(i .. ". " .. feikemon.nome, 25, yPos)
    end

    love.graphics.setColor(1, 1, 1, 1) -- Resetar cor
end

return TeamMenu