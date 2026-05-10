local TeamMenu = {
    isVisible = false,
    width = 250,
    font = nil,
    corFundo = {0.7, 0.55, 0.4},
    corBorda = {0.4, 0.23, 0.12},
    corTexto = {0.2, 0.1, 0.05},
    corVida  = {0.1, 0.5, 0.1}
}

function TeamMenu.load()
    TeamMenu.font = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18)
end

function TeamMenu.toggle()
    TeamMenu.isVisible = not TeamMenu.isVisible
end

function TeamMenu.draw(equipe)
    if not TeamMenu.isVisible then return end

    local h = love.graphics.getHeight()
    local w = TeamMenu.width

    local borderSize = 8
    local paddingY = 80
    local spacing = 50

    love.graphics.setColor(TeamMenu.corBorda)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setColor(TeamMenu.corFundo)
    love.graphics.rectangle("fill", borderSize, borderSize, w - (borderSize * 2), h - (borderSize * 2))

    love.graphics.setFont(TeamMenu.font)
    love.graphics.setColor(TeamMenu.corTexto)
    love.graphics.print("SUA EQUIPE", 25, 25)
    love.graphics.line(20, 55, w - 20, 55)

    for i, feikemon in ipairs(equipe) do
        local yPos = paddingY + (i - 1) * spacing

        love.graphics.setColor(TeamMenu.corTexto)
        love.graphics.print(i .. ". " .. feikemon.nome, 25, yPos)

        if feikemon.hp_atual <= 0 then
            love.graphics.setColor(0.8, 0.1, 0.1)
        else
            love.graphics.setColor(TeamMenu.corVida)
        end

        love.graphics.print("HP: " .. feikemon.hp_atual .. "/" .. feikemon.hp_max, 45, yPos + 22)
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return TeamMenu