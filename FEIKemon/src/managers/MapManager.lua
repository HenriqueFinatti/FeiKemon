
local MapManager = {}

local mapas = {
    ["sala de estudos"] = require 'src/maps/SalaDeEstudos',
    ["area externa"]    = require 'src/maps/AreaExterna',
    ["macfei"]    = require 'src/maps/MacFEI'
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
    end

    gameplay.player.collider:setPosition(x, y)
end

return MapManager