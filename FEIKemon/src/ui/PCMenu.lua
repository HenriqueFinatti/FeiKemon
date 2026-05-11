local PCMenu = {}

local fonte
local visivel = false
local abaAtual = "equipe" -- "equipe" ou "computador"
local selecionadoEquipe = 1
local selecionadoPC = 1

function PCMenu.load()
    fonte = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18)
end

function PCMenu.toggle()
    visivel = not visivel
    abaAtual = "equipe"
    selecionadoEquipe = 1
    selecionadoPC = 1
end

function PCMenu.isVisible()
    return visivel
end

function PCMenu.setVisible(v)
    visivel = v
    if v then
        abaAtual = "equipe"
        selecionadoEquipe = 1
        selecionadoPC = 1
    end
end

function PCMenu.controles(key, player)
    if not visivel then return end

    local maxEquipe = #player.equipe
    local maxPC = #player.computador

    if key == "t" or key == "escape" then
        visivel = false
        return
    end

    if key == "left" then
        abaAtual = "equipe"
    elseif key == "right" then
        abaAtual = "computador"
    end

    if abaAtual == "equipe" then
        if key == "up" then
            selecionadoEquipe = math.max(1, selecionadoEquipe - 1)
        elseif key == "down" then
            selecionadoEquipe = math.min(maxEquipe, selecionadoEquipe + 1)
        elseif key == "w" then
            -- Mover para cima na ordem
            if selecionadoEquipe > 1 then
                player.equipe[selecionadoEquipe], player.equipe[selecionadoEquipe - 1] =
                    player.equipe[selecionadoEquipe - 1], player.equipe[selecionadoEquipe]
                selecionadoEquipe = selecionadoEquipe - 1
            end
        elseif key == "s" then
            -- Mover para baixo na ordem
            if selecionadoEquipe < maxEquipe then
                player.equipe[selecionadoEquipe], player.equipe[selecionadoEquipe + 1] =
                    player.equipe[selecionadoEquipe + 1], player.equipe[selecionadoEquipe]
                selecionadoEquipe = selecionadoEquipe + 1
            end
        elseif key == "return" or key == "space" then
            -- Transferir do equipe para computador
            if maxEquipe > 1 then -- nao pode transferir o ultimo
                local feikemon = table.remove(player.equipe, selecionadoEquipe)
                table.insert(player.computador, feikemon)
                selecionadoEquipe = math.min(selecionadoEquipe, #player.equipe)
            end
        end
    elseif abaAtual == "computador" then
        if key == "up" then
            selecionadoPC = math.max(1, selecionadoPC - 1)
        elseif key == "down" then
            selecionadoPC = math.min(maxPC, selecionadoPC + 1)
        elseif key == "return" or key == "space" then
            -- Transferir do computador para equipe
            if maxEquipe < player.maxEquipe then
                local feikemon = table.remove(player.computador, selecionadoPC)
                table.insert(player.equipe, feikemon)
                selecionadoPC = math.min(selecionadoPC, #player.computador)
            end
        end
    end
end

function PCMenu.draw(player)
    if not visivel then return end

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    local boxW = sw * 0.8
    local boxH = sh * 0.7
    local boxX = (sw - boxW) / 2
    local boxY = (sh - boxH) / 2

    -- Fundo escuro semi-transparente
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, sw, sh)

    -- Caixa principal
    love.graphics.setColor(0.3, 0.2, 0.1)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(1, 0.8, 0)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH)
    love.graphics.setLineWidth(1)

    love.graphics.setFont(fonte)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("COMPUTADOR FEI", boxX + 20, boxY + 15)
    love.graphics.print("(T ou ESC para sair)", boxX + boxW - 220, boxY + 15)

    -- Separacao
    love.graphics.setColor(1, 0.8, 0)
    love.graphics.line(boxX + boxW/2, boxY + 50, boxX + boxW/2, boxY + boxH - 20)

    -- Coluna Equipe
    local cx = boxX + 20
    local cy = boxY + 55
    if abaAtual == "equipe" then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("> MOCHILA (" .. #player.equipe .. "/" .. player.maxEquipe .. ")", cx, cy)
    else
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print("MOCHILA (" .. #player.equipe .. "/" .. player.maxEquipe .. ")", cx, cy)
    end

    cy = cy + 30
    love.graphics.setColor(1, 1, 1)
    for i, f in ipairs(player.equipe) do
        if i == selecionadoEquipe and abaAtual == "equipe" then
            love.graphics.setColor(1, 1, 0)
            love.graphics.print("> " .. i .. ". " .. f.nome .. " Lv." .. f.level, cx, cy)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(i .. ". " .. f.nome .. " Lv." .. f.level, cx, cy)
        end
        cy = cy + 25
    end
    if #player.equipe == 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("(vazio)", cx, cy)
    end

    -- Coluna Computador
    cx = boxX + boxW/2 + 20
    cy = boxY + 55
    if abaAtual == "computador" then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print("> COMPUTADOR (" .. #player.computador .. ")", cx, cy)
    else
        love.graphics.setColor(0.7, 0.7, 0.7)
        love.graphics.print("COMPUTADOR (" .. #player.computador .. ")", cx, cy)
    end

    cy = cy + 30
    love.graphics.setColor(1, 1, 1)
    for i, f in ipairs(player.computador) do
        if i == selecionadoPC and abaAtual == "computador" then
            love.graphics.setColor(1, 1, 0)
            love.graphics.print("> " .. i .. ". " .. f.nome .. " Lv." .. f.level, cx, cy)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(i .. ". " .. f.nome .. " Lv." .. f.level, cx, cy)
        end
        cy = cy + 25
    end
    if #player.computador == 0 then
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.print("(vazio)", cx, cy)
    end

    -- Instrucoes
    love.graphics.setColor(0.8, 0.8, 0.8)
    if abaAtual == "equipe" then
        love.graphics.print("<- / -> : aba  |  ENTER : transferir  |  W/S : mover", boxX + 20, boxY + boxH - 30)
    else
        love.graphics.print("<- / -> : aba  |  ENTER : transferir", boxX + 20, boxY + boxH - 30)
    end

    love.graphics.setColor(1, 1, 1)
end

return PCMenu
