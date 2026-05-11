local SaveManager = require 'src/managers/SaveManager'

local MapManager = {}

local mapas = {
    ["sala de estudos"] = require 'src/maps/SalaDeEstudos',
    ["area externa"]    = require 'src/maps/AreaExterna',
    ["macfei"]          = require 'src/maps/MacFEI',
    ["k"]               = require 'src/maps/PredioK',
    ["predio k"]               = require 'src/maps/PredioK',
    ["igreja"]          = require 'src/maps/IgrejaFEI'
}

function MapManager.mudarMapa(porta, gameplay)
    local destino = porta.destino
    local x = porta.x
    local y = porta.y

    print("[MAP MANAGER] Mudando mapa para:", destino, "x:", x, "y:", y)
    print("[MAP MANAGER] Player existe?", tostring(gameplay.player ~= nil))
    print("[MAP MANAGER] Collider existe?", tostring(gameplay.player and gameplay.player.collider ~= nil))
    print("[MAP MANAGER] Mapa atual existe?", tostring(gameplay.mapaAtual ~= nil))

    if gameplay.mapaAtual and gameplay.mapaAtual.removeColliders then
        gameplay.mapaAtual:removeColliders()
    end

    local MapaClasse = mapas[destino]
    if MapaClasse then
        gameplay.mapaAtual = MapaClasse()
        print("[MAP MANAGER] Novo mapa criado:", gameplay.mapaAtual.name)
        gameplay.mapaAtual:setColliders()
        gameplay.player.currentMap = gameplay.mapaAtual.name

        -- Aplica estado salvo dos treinadores se houver
        SaveManager.aplicarEstadoTreinadores(gameplay.mapaAtual)
        print("[MAP MANAGER] Estado dos treinadores aplicado")
    else
        print("[MAP MANAGER] ERRO: Mapa nao encontrado:", destino)
    end

    if gameplay.player and gameplay.player.collider then
        gameplay.player.collider:setPosition(x, y)
        print("[MAP MANAGER] Player posicionado em", x, y)
    else
        print("[MAP MANAGER] ERRO: Player ou collider nulo!")
    end
end

return MapManager