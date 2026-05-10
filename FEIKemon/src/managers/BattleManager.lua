local feikedex = require 'src/utils/Feikedex'
local TeamMenu = require 'src/ui/TeamMenu'

local BattleManager = {
    chance = 0.05,
    inimigo = nil,
    playerRef = nil,
    menuAberto = "principal",
    indiceAtivo = 1,
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
    if GamePhase ~= "Gameplay" then return end

    if gameplay.mapaAtual.name == "area externa" then
        local vx, vy = gameplay.player.collider:getLinearVelocity()
        if math.abs(vx) > 0 or math.abs(vy) > 0 then
            if math.random() < BattleManager.chance then
                if gameplay.player:obterPrimeiroVivo() then
                    BattleManager.startBattle(gameplay.player)
                end
            end
        end
    end
end

function BattleManager.startBattle(player)
    if TeamMenu.isVisible then TeamMenu.toggle() end
    GamePhase = "Battle"
    BattleManager.playerRef = player

    BattleManager.indiceAtivo = player:obterPrimeiroVivo()

    local randomID = math.random(1, #feikedex.feikemons)
    BattleManager.inimigo = BattleManager.montaFeiKemon(randomID)

    print("\n==========================================")
    print("!!! UM " .. BattleManager.inimigo.nome:upper() .. " SELVAGEM APARECEU !!!")
    BattleManager.exibirMenuPrincipal()
end

function BattleManager.exibirMenuPrincipal()
    BattleManager.menuAberto = "principal"
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    print("\nO que " .. pFeikemon.nome .. " deve fazer?")
    print("1. Lutar | 2. Fugir | 3. Aprender")
    print("==========================================")
end

function BattleManager.exibirMenuGolpes()
    BattleManager.menuAberto = "golpes"
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    print("\nGolpes de " .. pFeikemon.nome .. ":")
    for i, nomeAtaque in ipairs(pFeikemon.ataques) do
        print(i .. ". " .. nomeAtaque)
    end
    print("5. Voltar")
end

function BattleManager.controles(key)
    if BattleManager.menuAberto == "principal" then
        if key == "1" then
            BattleManager.exibirMenuGolpes()
        elseif key == "2" then
            print("Você fugiu!")
            GamePhase = "Gameplay"
        elseif key == "3" then
            BattleManager.playerRef:captura(BattleManager.inimigo)
            GamePhase = "Gameplay"
        end
    elseif BattleManager.menuAberto == "golpes" then
        local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
        local num = tonumber(key)
        if num and num >= 1 and num <= #pFeikemon.ataques then
            BattleManager.executarTurno(pFeikemon.ataques[num])
        elseif key == "5" then
            BattleManager.exibirMenuPrincipal()
        end
    end
end

function BattleManager.executarTurno(ataqueNome)
    local pFeikemon = BattleManager.playerRef.equipe[BattleManager.indiceAtivo]
    local eFeikemon = BattleManager.inimigo

    -- Turno do Player
    local dadosAtaque = feikedex.ataques[ataqueNome]
    eFeikemon.hp_atual = math.max(0, eFeikemon.hp_atual - dadosAtaque.dano)
    print("\n>> " .. pFeikemon.nome .. " usou " .. ataqueNome .. "!")

    if eFeikemon.hp_atual <= 0 then
        print(">> O " .. eFeikemon.nome .. " selvagem desmaiou!")
        GamePhase = "Gameplay"
        return
    end

    local ataqueInimigoNome = eFeikemon.ataques[math.random(1, #eFeikemon.ataques)]
    local dadosAtaqueInimigo = feikedex.ataques[ataqueInimigoNome]
    pFeikemon.hp_atual = math.max(0, pFeikemon.hp_atual - dadosAtaqueInimigo.dano)

    print(">> " .. eFeikemon.nome .. " selvagem usou " .. ataqueInimigoNome .. "!")
    print(">> " .. pFeikemon.nome .. " tem " .. pFeikemon.hp_atual .. " HP restante.")

    if pFeikemon.hp_atual <= 0 then
        print("!! " .. pFeikemon.nome .. " desmaiou !!")

        local proximo = BattleManager.playerRef:obterPrimeiroVivo()
        if proximo then
            BattleManager.indiceAtivo = proximo
            local novoFeikemon = BattleManager.playerRef.equipe[proximo]
            print(">> Vai, " .. novoFeikemon.nome .. "!")
            BattleManager.exibirMenuPrincipal()
        else
            print(">> Você não tem mais FeiKemons em condições de lutar!")
            print(">> Você correu para o Centro Acadêmico para descansar...")
            GamePhase = "Gameplay"
        end
    else
        BattleManager.exibirMenuPrincipal()
    end
end

return BattleManager