local Transition = {}
local utf8 = require 'utf8'

local fullText = "Dia: 02/02/2026\n Finalmente chegou o dia da integração dos calouros na FEI.\n Estou muito empolgado para conhecer toda a escola, mas também meio nervoso...\nSerá que vou fazer amigos? Será que vou gostar do curso? É verdade que capotaram um carro la?"
local displayedText = ""
local finishedText = false
local timer = 0
local textSpeed = 0.05
local alpha = 0
local fadeSpeed = 1

function Transition.load()
    displayedText = ""
    timer = 0
    alpha = 0
    finishedText = false
end

function Transition.update(dt)
    if alpha < 1 then
        alpha = math.min(1, alpha + dt * fadeSpeed)
    end

    if alpha > 0.5 and #displayedText < #fullText then
        timer = timer + dt
        if timer >= textSpeed then
            timer = 0
            local charCount = utf8.len(displayedText)
            local nextByte = utf8.offset(fullText, charCount + 2)

            if nextByte then
                displayedText = fullText:sub(1, nextByte - 1)
            else
                finishedText = true
                displayedText = fullText
            end
        end
    end
end

function Transition.draw()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    love.graphics.setColor(0, 0, 0, alpha * 0.8)
    love.graphics.rectangle("fill", 0, 0, w, h)

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.printf(displayedText, 100, h / 3, w - 200, "center")

    if finishedText then
        local flash = math.abs(math.sin(love.timer.getTime() * 3))
        love.graphics.setColor(1, 1, 0, flash)
        love.graphics.printf("Pressione Enter para seguir >>", 0, h - 60, w - 50, "right")
    end
end

function Transition.keypressed(key)
    if key == "return" or key == "kpenter" then
        if not finishedText then
            displayedText = fullText
            finishedText = true
        else
            return "iniciar_gameplay"
        end
    end
end

return Transition