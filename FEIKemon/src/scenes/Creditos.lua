local Creditos = {}

local fonte
local nomes = {
    "FeiKemon",
    "",
    "Criado por:",
    "Henrique Finatti Silveira Belo Trebbi",
    "Tiago Fagundes dos Santos",
    "Mateus Marana Assuena",
    "Giovanni Chahin Morassi",
    "",
    "Obrigado por jogar!",
    "",
    "A FEI esta salva... por enquanto.",
}

local tempoPorLinha = 1.5
local tempoTotal
local alpha

function Creditos.load()
    fonte = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 32)
end

function Creditos.start()
    tempoTotal = 0
    alpha = 0
end

function Creditos.update(dt)
    tempoTotal = tempoTotal + dt
    if tempoTotal < 1 then
        alpha = tempoTotal
    elseif tempoTotal > #nomes * tempoPorLinha + 2 then
        alpha = math.max(0, (#nomes * tempoPorLinha + 3) - tempoTotal)
        if tempoTotal > #nomes * tempoPorLinha + 4 then
            GameState = "Jogo"
            GamePhase = "Gameplay"
        end
    else
        alpha = 1
    end
end

function Creditos.keypressed(key)
    if key == "return" or key == "space" or key == "escape" then
        GameState = "Jogo"
        GamePhase = "Gameplay"
    end
end

function Creditos.draw()
    love.graphics.clear(0, 0, 0)
    love.graphics.setFont(fonte)

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    for i, nome in ipairs(nomes) do
        local y = sh * 0.4 + (i - 1) * 50 - (tempoTotal * 40)
        if y > -50 and y < sh + 50 then
            local a = 1
            if y < sh * 0.3 then
                a = math.max(0, y / (sh * 0.3))
            elseif y > sh * 0.7 then
                a = math.max(0, (sh - y) / (sh * 0.3))
            end
            love.graphics.setColor(1, 1, 1, a * alpha)
            local fw = fonte:getWidth(nome)
            love.graphics.print(nome, (sw - fw) / 2, y)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

return Creditos
