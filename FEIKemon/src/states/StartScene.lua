local StartScene = {}

local smallFont = nil
local background, board
local buttonPlay = { x = 500, y = 550, w = 150, h = 50, text = "Jogar" }
local buttonExit = { x = 700, y = 550, w = 150, h = 50, text = "Sair" }

function StartScene.load()
    background = love.graphics.newImage("assets/backgroundInicial.png")
end

function StartScene.setup()
    smallFont = love.graphics.newFont('assets/font.ttf', 18)

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.graphics.setFont(smallFont)

    love.graphics.draw(
        background, 0, 0, 0,
        love.graphics.getWidth() / background:getWidth(),
        love.graphics.getHeight() / background:getHeight()
    )
end

local function drawButton(btn)
    love.graphics.setColor(0.3, 0.2, 0.1, 1) -- Colocando o fundo do botão marrom
    love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 5)

    love.graphics.setColor(1, 1, 0) -- Mudando a borda para cor amarela
    love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 5)

    love.graphics.setColor(1, 1, 0) -- Mudando o texto para amarelo
    love.graphics.printf(btn.text, btn.x, btn.y + 15, btn.w, "center")

    love.graphics.setColor(1, 1, 1, 1) -- Voltando o texto para branco
end

function StartScene.mousepressed(x, y, button)
    if button == 1 then -- Clique com o botão esquerdo
        if x >= buttonPlay.x and x <= buttonPlay.x + buttonPlay.w and
           y >= buttonPlay.y and y <= buttonPlay.y + buttonPlay.h then
            return "jogar"
        end

        if x >= buttonExit.x and x <= buttonExit.x + buttonExit.w and
           y >= buttonExit.y and y <= buttonExit.y + buttonExit.h then
            love.event.quit()
        end
    end
end

function StartScene.draw()
    StartScene.setup()

    drawButton(buttonPlay)
    drawButton(buttonExit)
end
return StartScene