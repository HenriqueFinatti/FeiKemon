local Class = require 'src/utils/Class'
local utf8 = require 'utf8'

local TextBoxManager = Class {}
local smallFont
local MARGIN = 15

function TextBoxManager:init()
    self.dialogoAtivo = false

    self.caracteresExibidos = 0
    self.velocidadeTexto = 30

    self.screenW = love.graphics.getWidth()
    self.screenH = love.graphics.getHeight()

    self.font = love.graphics.newFont('assets/fonts/8bitoperator.ttf', 18)

    self.boxH = self.screenH * 0.28
    self.boxX = MARGIN
    self.boxY = self.screenH - self.boxH - MARGIN
    self.boxW = self.screenW - (MARGIN * 2)

    self.padding = 20
    self.portraitSize = self.boxH - (self.padding * 2)

    self.textX = self.boxX + self.portraitSize + (self.padding * 2)
    self.textW = self.boxW - self.portraitSize - (self.padding * 4)
    
    self.corBorda = {0.35, 0.22, 0.12}  
    self.corFundo = {0.85, 0.75, 0.55}  
    self.corFonte = {0.25, 0.15, 0.08}
end

function TextBoxManager:update(dt, textoCompleto)
    if self.dialogoAtivo then
        
        if self.caracteresExibidos < #textoCompleto then
            self.caracteresExibidos = self.caracteresExibidos + (self.velocidadeTexto * dt)
        end
    end
end

function TextBoxManager:draw(falas)
    if self.dialogoAtivo then
        Cam:detach()
        local dialogo = falas[1]
        local textoCompleto = dialogo.texto
        
        local numCaracteres = math.floor(self.caracteresExibidos)
        
        local textoParcial = ""
        if numCaracteres > 0 then
            local byteOffset = utf8.offset(textoCompleto, numCaracteres + 1)
            
            if byteOffset then
                textoParcial = string.sub(textoCompleto, 1, byteOffset - 1)
            else
                textoParcial = textoCompleto
            end
        end

        self:drawDialogue(dialogo.retrato, dialogo.nome, textoParcial)
        Cam:attach()
    end
end

function TextBoxManager:drawDialogue(retrato, nome, texto)
    
    love.graphics.setFont(self.font)

    love.graphics.setColor(self.corFundo)
    love.graphics.rectangle("fill", self.boxX, self.boxY, self.boxW, self.boxH)

    love.graphics.setColor(self.corBorda)
    love.graphics.setLineWidth(8)
    love.graphics.rectangle("line", self.boxX, self.boxY, self.boxW, self.boxH)

    if retrato then
        love.graphics.setColor(1, 1, 1) 
        love.graphics.draw(retrato, self.boxX + self.padding, self.boxY + self.padding, 0, 
            self.portraitSize / retrato:getWidth(), 
            self.portraitSize / retrato:getHeight())
    end

    love.graphics.setColor(self.corFonte)
    love.graphics.print(nome .. ":", self.textX, self.boxY + self.padding)
    love.graphics.printf(texto, self.textX, self.boxY + self.padding + 30, self.textW)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
end

return TextBoxManager