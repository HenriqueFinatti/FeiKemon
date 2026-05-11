local SaveManager = {}

local SAVE_FILE = "savegame.json"

function SaveManager.salvar(gameplay)
    local ok, err = pcall(function()
        local data = {}

        -- Flags globais
        data.leilaDerrotada = gameplay.leilaDerrotada or false
        data.posJogo = gameplay.posJogo or false

        -- Player
        data.player = {
            x = gameplay.player.x,
            y = gameplay.player.y,
            currentMap = gameplay.player.currentMap,
        }

    -- Equipe do jogador
    data.equipe = {}
    for _, f in ipairs(gameplay.player.equipe) do
        table.insert(data.equipe, {
            nome = f.nome,
            hp_atual = f.hp_atual,
            ataques = f.ataques,
            level = f.level or 1,
            xp = f.xp or 0,
        })
    end

        -- Estado dos treinadores
        data.trainers = {}
        if gameplay.mapaAtual and gameplay.mapaAtual.trainers then
            local mapName = gameplay.mapaAtual.name or "unknown"
            data.trainers[mapName] = {}
            for _, t in ipairs(gameplay.mapaAtual.trainers) do
                data.trainers[mapName][t.nome] = t.derrotado
            end
        end

        -- Tambem salva de mapas que ja foram visitados anteriormente
        local oldData = SaveManager.carregarRaw()
        if oldData and oldData.trainers then
            for mapName, trainers in pairs(oldData.trainers) do
                if not data.trainers[mapName] then
                    data.trainers[mapName] = trainers
                end
            end
        end

        -- Configuracoes
        data.volume = love.audio.getVolume() or 0.5

        local json = SaveManager.toJson(data)
        love.filesystem.write(SAVE_FILE, json)
    end)

    if not ok then
        print("[SAVE ERROR] " .. tostring(err))
        return false, tostring(err)
    end
    return true
end

function SaveManager.carregarRaw()
    if not love.filesystem.getInfo(SAVE_FILE) then
        return nil
    end
    local contents, _ = love.filesystem.read(SAVE_FILE)
    if not contents then return nil end
    return SaveManager.fromJson(contents)
end

function SaveManager.carregar(gameplay)
    local ok, err = pcall(function()
        local data = SaveManager.carregarRaw()
        if not data then return false, "Nenhum save encontrado" end

        print("[SAVE LOAD] Dados carregados:")
        print("[SAVE LOAD]   Mapa:", tostring(data.player and data.player.currentMap))
        print("[SAVE LOAD]   X:", tostring(data.player and data.player.x))
        print("[SAVE LOAD]   Y:", tostring(data.player and data.player.y))
        print("[SAVE LOAD]   Leila derrotada:", tostring(data.leilaDerrotada))
        print("[SAVE LOAD]   Pos-jogo:", tostring(data.posJogo))

        -- Flags globais
        gameplay.leilaDerrotada = data.leilaDerrotada or false
        gameplay.posJogo = data.posJogo or false

        -- Player posicao e mapa
        if data.player then
            gameplay.player.x = data.player.x or gameplay.player.x
            gameplay.player.y = data.player.y or gameplay.player.y
            gameplay.player.currentMap = data.player.currentMap or gameplay.player.currentMap
        end

        -- Equipe
        if data.equipe and #data.equipe > 0 then
            gameplay.player.equipe = {}
            local BattleManager = require 'src/managers/BattleManager'
            for _, savedF in ipairs(data.equipe) do
                local baseId = nil
                for i, base in ipairs(require('src/utils/Feikedex').feikemons) do
                    if base.nome == savedF.nome then
                        baseId = i
                        break
                    end
                end
            if baseId then
                local level = savedF.level or 1
                local f = BattleManager.montaFeiKemon(baseId, level)
                f.hp_atual = math.min(savedF.hp_atual or f.hp_max, f.hp_max)
                f.xp = savedF.xp or 0
                if savedF.ataques then
                    f.ataques = savedF.ataques
                end
                table.insert(gameplay.player.equipe, f)
            end
            end
        end

        -- Volume
        if data.volume then
            love.audio.setVolume(data.volume)
            if BackgroundMusic then
                BackgroundMusic:setVolume(data.volume)
            end
        end

        -- Treinadores: aplicar estado quando o mapa for carregado
        SaveManager._trainerState = data.trainers or {}

        -- Forcar teleporte para o mapa salvo
        if data.player and data.player.currentMap then
            local MapManager = require 'src/managers/MapManager'
            local porta = {
                destino = data.player.currentMap,
                x = data.player.x or 0,
                y = data.player.y or 0,
            }
            MapManager.mudarMapa(porta, gameplay)
        end

        return true
    end)

    if not ok then
        print("[LOAD ERROR] " .. tostring(err))
        return false, tostring(err)
    end
    return true
end

function SaveManager.aplicarEstadoTreinadores(mapa)
    if not SaveManager._trainerState then return end
    if not mapa or not mapa.name then return end
    local state = SaveManager._trainerState[mapa.name]
    if not state or not mapa.trainers then return end
    for _, t in ipairs(mapa.trainers) do
        if state[t.nome] ~= nil then
            t.derrotado = state[t.nome]
        end
    end
end

function SaveManager.existeSave()
    return love.filesystem.getInfo(SAVE_FILE) ~= nil
end

-- Serializador que gera codigo Lua valido (para usar com load())
function SaveManager.toJson(tbl)
    local function serialize(v)
        local t = type(v)
        if t == "nil" then return "nil"
        elseif t == "boolean" then return v and "true" or "false"
        elseif t == "number" then return tostring(v)
        elseif t == "string" then return string.format("%q", v)
        elseif t == "table" then
            local isArray = true
            local maxIndex = 0
            for k, _ in pairs(v) do
                if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
                    isArray = false
                    break
                end
                maxIndex = math.max(maxIndex, k)
            end
            if isArray and maxIndex ~= #v then isArray = false end

            local parts = {}
            if isArray then
                for _, val in ipairs(v) do
                    table.insert(parts, serialize(val))
                end
                return "{" .. table.concat(parts, ",") .. "}"
            else
                for k, val in pairs(v) do
                    local key
                    if type(k) == "string" then
                        key = "[" .. string.format("%q", k) .. "]"
                    else
                        key = "[" .. tostring(k) .. "]"
                    end
                    table.insert(parts, key .. "=" .. serialize(val))
                end
                return "{" .. table.concat(parts, ",") .. "}"
            end
        end
        return "nil"
    end
    return serialize(tbl)
end

function SaveManager.fromJson(str)
    if not str or str == "" then return nil end
    local func, err = load("return " .. str, "save", "t", {})
    if not func then
        print("[PARSE ERROR] " .. tostring(err))
        return nil
    end
    local ok, result = pcall(func)
    if ok then return result else
        print("[EXEC ERROR] " .. tostring(result))
        return nil
    end
end

return SaveManager
