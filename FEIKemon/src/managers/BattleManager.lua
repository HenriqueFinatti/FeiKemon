local feikedex = require 'src/utils/Feikedex'

local BattleManager = {
    chance = 0.05, -- Diminuído para não triggar toda hora
    inimigo = nil,
    playerRef = nil,
    menuAberto = "principal", -- "principal" ou "golpes"
}

function BattleManager.montaFeiKemon(id)
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
    -- Só checa encontro se estivermos explorando
    if GamePhase ~= "Gameplay" then return end

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
    GamePhase = "Battle"
    BattleManager.playerRef = player

    local randomID = math.random(1, #feikedex.feikemons)
    BattleManager.inimigo = BattleManager.montaFeiKemon(randomID)

    print("\n==========================================")
    print("!!! UM " .. BattleManager.inimigo.nome:upper() .. " SELVAGEM APARECEU !!!")
    BattleManager.exibirMenuPrincipal()
end

function BattleManager.exibirMenuPrincipal()
    BattleManager.menuAberto = "principal"
    print("\nO que " .. BattleManager.playerRef.equipe[1].nome .. " deve fazer?")
    print("1. Lutar")
    print("2. Fugir")
    print("3. Aprender (Capturar)")
    print("==========================================")
end

function BattleManager.exibirMenuGolpes()
    BattleManager.menuAberto = "golpes"
    local pFeikemon = BattleManager.playerRef.equipe[1]
    print("\nEscolha um golpe:")
    for i, nomeAtaque in ipairs(pFeikemon.ataques) do
        print(i .. ". " .. nomeAtaque)
    end
    print("5. Voltar")
end

function BattleManager.controles(key)
    if BattleManager.menuAberto == "principal" then
        if key == "1" then
            print("Esta aqui")
            BattleManager.exibirMenuGolpes()
        elseif key == "2" then
            print("Você fugiu com segurança!")
            GamePhase = "Gameplay"
        elseif key == "3" then
            BattleManager.playerRef:captura(BattleManager.inimigo)
            GamePhase = "Gameplay"
        end

    elseif BattleManager.menuAberto == "golpes" then
        local pFeikemon = BattleManager.playerRef.equipe[1]
        local num = tonumber(key)

        if num and num >= 1 and num <= #pFeikemon.ataques then
            BattleManager.executarTurno(pFeikemon.ataques[num])
        elseif key == "5" then
            BattleManager.exibirMenuPrincipal()
        end
    end
end

function BattleManager.executarTurno(ataqueNome)
    local pFeikemon = BattleManager.playerRef.equipe[1]
    local eFeikemon = BattleManager.inimigo

    -- Turno do Player
    local dadosAtaque = feikedex.ataques[ataqueNome]
    eFeikemon.hp_atual = math.max(0, eFeikemon.hp_atual - dadosAtaque.dano)
    print("\n>> " .. pFeikemon.nome .. " usou " .. ataqueNome .. "!")
    print(">> " .. eFeikemon.nome .. " selvagem tem " .. eFeikemon.hp_atual .. " HP restante.")

    if eFeikemon.hp_atual <= 0 then
        print(">> O " .. eFeikemon.nome .. " selvagem desmaiou!")
        GamePhase = "Gameplay"
        return
    end

    -- Turno do Inimigo (IA Simples)
    local ataqueInimigoNome = eFeikemon.ataques[math.random(1, #eFeikemon.ataques)]
    local dadosAtaqueInimigo = feikedex.ataques[ataqueInimigoNome]
    pFeikemon.hp_atual = math.max(0, pFeikemon.hp_atual - dadosAtaqueInimigo.dano)

    print(">> " .. eFeikemon.nome .. " selvagem usou " .. ataqueInimigoNome .. "!")
    print(">> Seu " .. pFeikemon.nome .. " tem " .. pFeikemon.hp_atual .. " HP restante.")

    if pFeikemon.hp_atual <= 0 then
        print(">> Seu FeiKemon desmaiou! Você correu para o hospital da faculdade.")
        GamePhase = "Gameplay"
    else
        BattleManager.exibirMenuPrincipal()
    end
end

return BattleManager