local feikedex = require 'src/utils/Feikedex'

local BattleManager = {
    chance = 0.05
}

function BattleManager.captura(id)
    local base = feikedex.feikemons[id]
    if not base then return nil end

    return {
        nome = base.nome,
        tipo = base.tipo,
        hp_max = base.hp_max,
        hp_atual = base.hp_max,
        ataques = base.ataques
    }
end

function BattleManager.check(dt, gameplay)
    if gameplay.mapaAtual.name == "area externa" then
        local vx, vy = gameplay.player.collider:getLinearVelocity()
        if math.abs(vx) > 0 or math.abs(vy) > 0 then

            if math.random() < BattleManager.chance then
                BattleManager.startBattle(gameplay.player)
            end
        end
    end
end

function BattleManager.startBattle(player)
    local randomID = math.random(1, #feikedex.feikemons)
    local selvagem = BattleManager.captura(randomID)

    print("\n------------------------------------------")
    print("!!! UM " .. selvagem.nome:upper() .. " SELVAGEM APARECEU !!!")
    print("Tipo: " .. selvagem.tipo[1] .. " | HP: " .. selvagem.hp_atual)
    print("------------------------------------------")

    player:mostrarEquipe()
end

return BattleManager