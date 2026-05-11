local Menu = {}

local smallFont = nil
local background
local clickSound

local buttonPlay, buttonLoad, buttonExit

function Menu.load()
    background = love.graphics.newImage("assets/images/BackgroundInicial.png")
    smallFont = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18)
    clickSound = love.audio.newSource("assets/sounds/mouseClick.mp3", "static")

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local buttonWidth = 200
    local buttonHeight = 50
    local spacing = 20

    local startX = (screenWidth - buttonWidth) / 2
    local baseY = (screenHeight) / 2 + screenHeight / 6

    buttonPlay = {
        x = startX,
        y = baseY,
        w = buttonWidth,
        h = buttonHeight,
        text = "Novo Jogo"
    }

    buttonLoad = {
        x = startX,
        y = baseY + buttonHeight + spacing,
        w = buttonWidth,
        h = buttonHeight,
        text = "Carregar Jogo"
    }

    buttonExit = {
        x = startX,
        y = baseY + (buttonHeight + spacing) * 2,
        w = buttonWidth,
        h = buttonHeight,
        text = "Sair"
    }
end

function Menu.setup()
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

function Menu.mousepressed(x, y, button)
    clickSound:play()
    BackgroundMusic:stop()
    if button == 1 then
        if x >= buttonPlay.x and x <= buttonPlay.x + buttonPlay.w and
           y >= buttonPlay.y and y <= buttonPlay.y + buttonPlay.h then
            return "jogar"
        end

        if x >= buttonLoad.x and x <= buttonLoad.x + buttonLoad.w and
           y >= buttonLoad.y and y <= buttonLoad.y + buttonLoad.h then
            return "carregar"
        end

        if x >= buttonExit.x and x <= buttonExit.x + buttonExit.w and
           y >= buttonExit.y and y <= buttonExit.y + buttonExit.h then
            love.event.quit()
        end
    end
end

function Menu.draw()
    Menu.setup()

    drawButton(buttonPlay)
    drawButton(buttonLoad)
    drawButton(buttonExit)
end

return Menu
