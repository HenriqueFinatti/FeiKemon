local SaveManager = require 'src/managers/SaveManager'

local MapManager = {}

local mapas = {
    ["sala de estudos"] = require 'src/maps/SalaDeEstudos',
    ["area externa"]    = require 'src/maps/AreaExterna',
    ["macfei"]          = require 'src/maps/MacFEI',
    ["k"]               = require 'src/maps/PredioK',
    ["igreja"]          = require 'src/maps/IgrejaFEI'
}

function MapManager.mudarMapa(porta, gameplay)

    local destino = porta.destino
    local x = porta.x
    local y = porta.y

    if gameplay.mapaAtual and gameplay.mapaAtual.removeColliders then
        gameplay.mapaAtual:removeColliders()
    end

    local MapaClasse = mapas[destino]
    if MapaClasse then
        gameplay.mapaAtual = MapaClasse()
        gameplay.mapaAtual:setColliders()
        gameplay.player.currentMap = gameplay.mapaAtual.name

        -- Aplica estado salvo dos treinadores se houver
        SaveManager.aplicarEstadoTreinadores(gameplay.mapaAtual)
    end

    gameplay.player.collider:setPosition(x, y)
end

return MapManager