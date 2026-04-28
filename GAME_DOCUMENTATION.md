# FEIKemon — Documentação Completa do Jogo

> Projeto acadêmico desenvolvido para a disciplina **Desenvolvimento de Jogos Digitais (CC7140)**  
> Centro Universitário FEI — São Bernardo do Campo, SP  
> Engine: **LÖVE2D (Love2D)** | Linguagem: **Lua**

---

## Sumário

1. [Visão Geral](#1-visão-geral)
2. [Estrutura de Pastas](#2-estrutura-de-pastas)
3. [Fluxo do Jogo](#3-fluxo-do-jogo)
4. [Sistemas Implementados](#4-sistemas-implementados)
5. [Mecânicas Implementadas](#5-mecânicas-implementadas)
6. [Mecânicas Projetadas (não implementadas)](#6-mecânicas-projetadas-não-implementadas)
7. [Tabela de Tipos](#7-tabela-de-tipos)
8. [Entidades](#8-entidades)
9. [FEIKemons](#9-feikemons)
10. [Mapas e Fases](#10-mapas-e-fases)
11. [Mundo e Progressão](#11-mundo-e-progressão)
12. [Bosses](#12-bosses)
13. [Áudio](#13-áudio)
14. [UI e Estética](#14-ui-e-estética)
15. [Bibliotecas de Terceiros](#15-bibliotecas-de-terceiros)
16. [Status de Implementação](#16-status-de-implementação)

---

## 1. Visão Geral

**FEIKemon** é um RPG turn-based inspirado em Pokémon, ambientado no campus do **Centro Universitário FEI**. O jogador é um calouro que chega à FEI no dia da integração e descobre que o campus é habitado por criaturas chamadas **FEIKemons** — monstrinhos temáticos do universo de tecnologia, computação e cultura universitária.

### Premissa Narrativa

> *"Dia: 02/02/2026. Finalmente chegou o dia da integração dos calouros na FEI. Estou muito empolgado para conhecer toda a escola, mas também meio nervoso... Será que vou fazer amigos? Será que vou gostar do curso? É verdade que capotaram um carro lá?"*

O jogador explora o campus, batalha contra professores, captura FEIKemons e desafia os **Mestres da FEI** — o equivalente à Elite 4 do Pokémon. O antagonista final é o **Boss da Mauá** (universidade rival).

### Equivalências Temáticas

| Pokémon | FEIKemon |
|---|---|
| Pokémon | FEIKemon |
| Pokébola | Feikebola |
| Centro Pokémon | MacFEI |
| Professor Carvalho | Prof. Danilo |
| Ginásios | Prédios da FEI |
| Elite 4 | Mestres da FEI |
| Campeão | Boss da Mauá |

---

## 2. Estrutura de Pastas

```
FeiKemon/                               ← Raiz do repositório
│
├── GAME_DOCUMENTATION.md               ← Este arquivo
├── README.md                           ← Info do projeto e membros da equipe
├── ataques.md                          ← Diagrama de tipos (Mermaid)
│
├── Docs/                               ← Documentação do design
│   ├── 1 - Introdução.md
│   ├── 2 - Publico Alvo.md
│   ├── 3 - Estetica.md
│   ├── 4 - Dinamica.md
│   ├── 5 - Mecanica.md
│   ├── 6 - De Para Pokemon x FeiKemon.md
│   ├── Game Design Document/
│   │   ├── GDD 1 Pagina/               ← GDD resumido (.pdf + .tex)
│   │   └── GDD 10 Paginas/             ← GDD completo (.pdf + .tex + mapa de controles)
│   ├── Prototipacao/                   ← Mockups e wireframes das telas
│   │   ├── Batalha.jpeg
│   │   ├── BatalhaGolpes.jpeg
│   │   ├── Igreja.jpeg
│   │   ├── MacFEI.jpeg
│   │   ├── MapaDaFEI.jpeg
│   │   ├── MenuDePokemons.jpeg
│   │   ├── PredioK.jpeg
│   │   ├── Prototipacao.pdf
│   │   └── SalaDeEstudos.jpeg
│   └── References/
│       └── references.md               ← Atribuição de assets e referências
│
└── FEIKemon/                           ← Diretório raiz do projeto Love2D
    ├── main.lua                        ← Ponto de entrada do jogo
    │
    ├── assets/
    │   ├── characters/                 ← Spritesheets dos NPCs (PNG)
    │   │   ├── Charles.png
    │   │   ├── Danilo.png
    │   │   ├── Fagner.png
    │   │   ├── Leila.png
    │   │   ├── Leo.png
    │   │   ├── Luciano.png
    │   │   ├── Marcio.png              ← Aguardando implementação
    │   │   ├── Maua.png                ← Aguardando implementação
    │   │   ├── Padre.png               ← Aguardando implementação
    │   │   ├── Plinio.png
    │   │   └── Samir.png               ← Aguardando implementação
    │   ├── fonts/
    │   │   └── 8bitoperator.ttf        ← Fonte pixel art principal
    │   ├── images/
    │   │   ├── BackgroundInicial.png   ← Fundo da tela de menu
    │   │   ├── player.png              ← Sprite estático do jogador
    │   │   └── predioK.png             ← Imagem do Prédio K
    │   ├── maps/
    │   │   ├── sala_de_estudos/        ← Mapa da Sala de Estudos
    │   │   │   ├── sala_estudos.lua    ← Mapa exportado pelo Tiled (formato Lua)
    │   │   │   ├── sala_estudos.tmx    ← Arquivo fonte do Tiled
    │   │   │   ├── *.tsx               ← Arquivos de tileset do Tiled
    │   │   │   └── *.png               ← Imagens dos tilesets
    │   │   └── sprites/images/         ← Cópia de referência das imagens de tileset
    │   ├── PixelArtsFeiKemon/          ← Pixel art dos FEIKemons
    │   │   ├── <Nome>Frente.png        ← Sprite de batalha (visão frontal)
    │   │   └── <Nome>Costas.png        ← Sprite de batalha (visão traseira)
    │   ├── player/
    │   │   └── player-sheet.png        ← Spritesheet 4 direções do jogador
    │   └── sounds/
    │       ├── backgroundMusicStart.mp3
    │       ├── Cloud Country.mp3
    │       └── mouseClick.mp3
    │
    └── src/
        ├── entities/                   ← Classes Lua de todos os personagens
        │   ├── Player.lua
        │   ├── Charles.lua
        │   ├── Danilo.lua
        │   ├── Fagner.lua
        │   ├── Leila.lua
        │   ├── Leo.lua
        │   ├── Luciano.lua
        │   └── Plinio.lua
        ├── libs/                       ← Bibliotecas de terceiros
        │   ├── anim8.lua               ← Animação de sprites
        │   ├── camera.lua              ← Sistema de câmera 2D
        │   ├── sti/                    ← Simple Tiled Implementation (carrega mapas Tiled)
        │   └── windfield/              ← Wrapper de física Box2D
        ├── maps/
        │   └── SalaDeEstudos.lua       ← Classe que carrega e desenha o mapa
        ├── scenes/
        │   └── Onboarding.lua          ← Cena cinemática de introdução
        ├── states/
        │   ├── Gameplay.lua            ← Estado principal de jogo
        │   ├── Menu.lua                ← Tela de título
        │   └── Transition.lua          ← Tela de transição narrativa
        └── utils/
            ├── Class.lua               ← Sistema OOP para Lua (HUMP)
            └── TextBoxManager.lua      ← Sistema de caixas de diálogo
```

---

## 3. Fluxo do Jogo

```
┌─────────────────────────────────────────────────────────────────┐
│                         main.lua                                │
│                     (ponto de entrada)                          │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                    gameState = "Jogo"  ← hardcoded em dev
                    (normalmente: "Menu")
                              │
          ┌───────────────────┼────────────────────┐
          ▼                   ▼                    ▼
   ┌─────────────┐   ┌──────────────────┐   ┌─────────────────┐
   │  Menu.lua   │   │ Transition.lua   │   │  Gameplay.lua   │
   │             │   │                  │   │                 │
   │ Tela título │   │ Texto narrativo  │   │ Loop principal  │
   │ Jogar/Sair  │   │ (typewriter)     │   │ de gameplay     │
   └──────┬──────┘   └────────┬─────────┘   └────────┬────────┘
          │                   │                       │
    clica "Jogar"       pressiona Enter         GamePhase
          │                   │               ┌──────┴───────┐
          ▼                   ▼               ▼              ▼
   gameState =         gameState =       "Onboarding"  "Gameplay"
   "Transition"         "Jogo"               │              │
                                             │         Jogador
                                       Cena cinemática  controlável
                                       câmera pan +     câmera segue
                                       diálogo Danilo   o jogador
                                             │
                                    (diálogo termina)
                                             │
                                             ▼
                                       GamePhase =
                                        "Gameplay"
```

> **Nota de desenvolvimento:** `main.lua` atualmente inicia direto em `gameState = "Jogo"`, pulando o Menu. Isso é intencional para acelerar o ciclo de desenvolvimento.

---

## 4. Sistemas Implementados

### 4.1 Sistema de Estados do Jogo

**Arquivo:** `FEIKemon/main.lua`

O jogo é controlado por uma variável global `gameState` que roteia todos os callbacks do Love2D (`update`, `draw`, `keypressed`, `mousepressed`) para o estado ativo.

```lua
-- main.lua — roteamento de estados
function love.update(dt)
    if gameState == "Menu" then
        Menu.update(dt)
    elseif gameState == "Transition" then
        local action = Transition.update(dt)
        if action == "iniciar_gameplay" then
            gameState = "Jogo"
            Gameplay.music()
        end
    elseif gameState == "Jogo" then
        Gameplay.update(dt)
    end
end
```

Cada estado expõe os métodos: `load()`, `update(dt)`, `draw()`, `keypressed(key)`, `mousepressed(x, y, button)`.

---

### 4.2 Sistema de Câmera

**Arquivo:** `FEIKemon/src/libs/camera.lua`  
**Usado em:** `Gameplay.lua`, `Onboarding.lua`

Câmera 2D com suporte a zoom, pan e attach/detach para renderização em espaços distintos (world-space vs. screen-space).

```lua
-- Gameplay.lua — inicialização da câmera
local screenWidth  = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local baseZoom     = math.min(screenWidth / mapWidth, screenHeight / mapHeight)
Cam = camera.new()
Cam.zoom = baseZoom * 2.5   -- zoom extra para pixel art legível

-- Renderização: world-space dentro do attach/detach
function Gameplay.draw()
    Cam:attach()
        SalaDeEstudosInstance:draw()
        PlayerInstance:draw()
    Cam:detach()
    -- UI desenhada fora (screen-space)
    TextBoxManagerGlobal:draw()
end

-- Seguir o jogador
Cam:lookAt(PlayerInstance.x, PlayerInstance.y)
```

No **Onboarding**, a câmera executa um pan cinemático automático em duas etapas:

```lua
-- Onboarding.lua — pan da câmera em dois eixos
if not panXDone then
    camX = camX - 80 * dt   -- move no eixo X
    if camX <= -209 then
        camX = -209
        panXDone = true
    end
elseif not panYDone then
    camY = camY - 80 * dt   -- move no eixo Y
    if camY <= -107 then
        camY = -107
        panYDone = true
        TextBoxManagerGlobal.dialogoAtivo = true  -- ativa diálogo ao fim do pan
    end
end
Cam:lookAt(camX, camY)
```

---

### 4.3 Sistema de Física e Colisões

**Arquivo:** `FEIKemon/src/libs/windfield/`  
**Usado em:** `Gameplay.lua`, `SalaDeEstudos.lua`, `Player.lua`

Wrapper sobre o Box2D integrado ao Love2D. Gravidade zerada (top-down).

```lua
-- Gameplay.lua — criação do mundo físico
World = wf.newWorld(0, 0, true)  -- sem gravidade

-- SalaDeEstudos.lua — criação de colisores para cada objeto do mapa
function SalaDeEstudos:setColliders()
    local layer = self.map.layers["Collision"]
    for _, obj in ipairs(layer.objects) do
        local collider = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
        collider:setType("static")
    end
end

-- Player.lua — colisor do jogador (retângulo com bordas arredondadas)
self.collider = World:newBSGRectangleCollider(x, y, 12, 15, 2)
self.collider:setFixedRotation(true)
```

A física é atualizada todo frame: `World:update(dt)`.

---

### 4.4 Sistema de Animação

**Arquivo:** `FEIKemon/src/libs/anim8.lua`  
**Usado em:** `Player.lua`, todos os NPCs

Biblioteca que define grids de spritesheet e sequências de frames.

```lua
-- Player.lua — definição das animações por direção
local g = anim8.newGrid(12, 18, sprite:getWidth(), sprite:getHeight())
--                       ↑w  ↑h  ↑largura total da imagem

self.animations = {
    down  = anim8.newAnimation(g('1-4', 1), 0.1),  -- linha 1, frames 1-4
    left  = anim8.newAnimation(g('1-4', 2), 0.1),  -- linha 2, frames 1-4
    right = anim8.newAnimation(g('1-4', 3), 0.1),
    up    = anim8.newAnimation(g('1-4', 4), 0.1),
}
self.currentAnim = self.animations.down

-- Atualização
self.currentAnim:update(dt)

-- Renderização
self.currentAnim:draw(self.sprite, drawX, drawY)

-- Parado: trava no frame 1
self.currentAnim:gotoFrame(1)
```

**NPCs** usam a mesma biblioteca com grid de `16×32` px:

```lua
-- Danilo.lua (padrão de todos os NPCs)
local g = anim8.newGrid(16, 32, sprite:getWidth(), sprite:getHeight())
self.animation = anim8.newAnimation(g('1-4', 1), 0.1)
```

---

### 4.5 Sistema de Caixas de Diálogo

**Arquivo:** `FEIKemon/src/utils/TextBoxManager.lua`  
**Global:** `TextBoxManagerGlobal`

Sistema de UI de diálogo com efeito typewriter, retrato do personagem e suporte a múltiplas falas encadeadas.

```lua
-- Estrutura de uma fala
{
    nome   = "Danilo",           -- nome exibido acima do texto
    texto  = "Olá, sejam...",    -- texto com efeito typewriter
    retrato = self.portrait      -- imagem do personagem (opcional)
}

-- Carregamento de um array de falas
TextBoxManagerGlobal:setFalas({
    { nome="Danilo", texto="Olá, sejam todos bem vindos a FEI!", retrato=portrait },
    { nome="Danilo", texto="E vocês sabem por que somos a melhor?", retrato=portrait },
    { nome="Danilo", texto="FEIKemons são monstrinhos estudados aqui...", retrato=portrait },
})
```

**Interação com Enter:**

```lua
-- TextBoxManager.lua — lógica de interação
function TextBoxManager:interagir()
    if self.charIndex < #self.textoAtual then
        -- texto ainda digitando: completa instantaneamente
        self.charIndex = #self.textoAtual
    else
        -- texto completo: avança para a próxima fala
        self.falaAtual = self.falaAtual + 1
        if self.falaAtual > #self.falas then
            self.dialogoAtivo = false  -- fecha o diálogo
            GamePhase = "Gameplay"     -- libera controle ao jogador
        end
    end
end
```

**Layout da caixa de diálogo:**

```
┌──────────────────────────────────────────────────────────┐
│ [RETRATO]  DANILO                                        │
│            Olá, sejam todos bem vindos a FEI!            │
│            A melhor faculdade de todas.                  │
│                                             ▼ Enter      │
└──────────────────────────────────────────────────────────┘
 ← 28% da altura da tela, encostada na base da janela
```

---

### 4.6 Sistema de Carregamento de Mapas

**Arquivo:** `FEIKemon/src/maps/SalaDeEstudos.lua`  
**Biblioteca:** `STI` (Simple Tiled Implementation) — `FEIKemon/src/libs/sti/`

Carrega mapas criados no editor **Tiled** exportados no formato Lua.

```lua
-- SalaDeEstudos.lua
local sti = require "src.libs.sti"

function SalaDeEstudos:new()
    self.map = sti("assets/maps/sala_de_estudos/sala_estudos.lua")
    self:setColliders()
end

-- Ordem de renderização das 8 camadas
function SalaDeEstudos:draw()
    self.map:drawLayer(self.map.layers["Collision"])       -- 1. debug de colisão
    self.map:drawLayer(self.map.layers["Ground And Walls"])-- 2. chão e paredes
    self.map:drawLayer(self.map.layers["Stage"])           -- 3. palco/podium
    self.map:drawLayer(self.map.layers["Shadows"])         -- 4. sombras do palco
    self.map:drawLayer(self.map.layers["Desks"])           -- 5. carteiras
    self.map:drawLayer(self.map.layers["Chairs"])          -- 6. cadeiras
    self.map:drawLayer(self.map.layers["Decoration"])      -- 7. decoração
    self.map:drawLayer(self.map.layers["NPCs"])            -- 8. posições dos NPCs
end
```

---

## 5. Mecânicas Implementadas

### 5.1 Movimento do Jogador

**Arquivo:** `FEIKemon/src/entities/Player.lua`

- **Controles:** `W`/`↑` (cima), `S`/`↓` (baixo), `A`/`←` (esquerda), `D`/`→` (direita)
- **Velocidade:** 80 unidades/segundo
- **Colisão:** resolvida pelo windfield/Box2D automaticamente
- **Animação:** muda de direção conforme a tecla pressionada; para ao soltar

```lua
function Player:update(dt)
    local vx, vy = 0, 0

    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        vy = -self.speed
        self.currentAnim = self.animations.up
    elseif love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        vy = self.speed
        self.currentAnim = self.animations.down
    end

    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        vx = -self.speed
        self.currentAnim = self.animations.left
    elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        vx = self.speed
        self.currentAnim = self.animations.right
    end

    self.collider:setLinearVelocity(vx, vy)

    -- sincroniza posição com o colisor físico
    self.x, self.y = self.collider:getPosition()

    if vx == 0 and vy == 0 then
        self.currentAnim:gotoFrame(1)  -- idle
    else
        self.currentAnim:update(dt)
    end
end
```

### 5.2 Câmera Cinemática (Onboarding)

**Arquivo:** `FEIKemon/src/scenes/Onboarding.lua`

- Ao iniciar o jogo, a câmera faz um pan automático pelo mapa
- **Etapa 1:** câmera desloca no eixo X de `-16` até `-209` (velocidade 80 u/s)
- **Etapa 2:** câmera desloca no eixo Y de `165` até `-107` (velocidade 80 u/s)
- Ao final do pan, o diálogo de introdução é ativado automaticamente

### 5.3 Diálogo com Typewriter

**Arquivo:** `FEIKemon/src/utils/TextBoxManager.lua`

- O texto é exibido caractere a caractere a cada `0.05s`
- UTF-8 safe: usa `utf8.offset` para não cortar caracteres especiais (ã, ç, etc.)
- Pressionar `Enter` durante a digitação exibe o texto completo instantaneamente
- Pressionar `Enter` novamente avança para a próxima fala ou fecha o diálogo

---

## 6. Mecânicas Projetadas (não implementadas)

### 6.1 Sistema de Batalha Turn-Based

Baseado no GDD (`Docs/5 - Mecanica.md`):

- Batalhas iniciam ao colidir com FEIKemons selvagens ou falar com um treinador
- Menu de batalha com 4 opções: **Atacar**, **Fugir**, **Capturar**, **Trocar FEIKemon**
- Cada turno: jogador escolhe ação → adversário escolhe ação → resolução por velocidade (Speed stat)
- Vitória: inimigo desmaia → jogador ganha XP
- Derrota: todos os FEIKemons do jogador desmaiaram → blackout → teleporte ao **MacFEI de baixo**

### 6.2 Captura de FEIKemons

- Usar **Feikebola** em batalha tenta capturar o FEIKemon selvagem
- Taxa de captura influenciada por: HP restante do alvo, tipo de Feikebola, status (paralisia, sono)
- Não é possível capturar FEIKemons de outros treinadores
- Time máximo: **6 FEIKemons**

### 6.3 Gestão de Time

- Tela de gerenciamento do time (mockup em `Docs/Prototipacao/MenuDePokemons.jpeg`)
- Trocar FEIKemons de posição, ver stats, ver movimentos
- Caixa de armazenamento para FEIKemons excedentes

### 6.4 Progressão de Nível (XP)

- FEIKemons ganham XP ao vencer batalhas
- Ao acumular XP suficiente: sobe de nível, aumenta os stats base
- Possibilidade de aprender novos golpes ao subir de nível

### 6.5 Cura (MacFEI)

- Ao entrar no **MacFEI**, todos os FEIKemons do time são curados automaticamente
- MacFEI de cima: ponto de cura normal durante a progressão
- MacFEI de baixo: ponto de retorno após derrota (penalty point)

---

## 7. Tabela de Tipos

FEIKemons possuem até **2 tipos**. A tabela abaixo mostra a efetividade de ataques:

| Ataque ↓ / Defesa → | Sistema | Físico | Energia | Bug | Gordura | Teoria |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Sistema**  | 1×  | 2×  | 0.5× | 2×  | 0.5× | 1×  |
| **Físico**   | 2×  | 1×  | 0.5× | 0×  | 2×   | 0.5× |
| **Energia**  | 1×  | 0.5×| 1×   | 2×  | 0.5× | 2×  |
| **Bug**      | 2×  | 1×  | 1×   | 0.5×| 1×   | 2×  |
| **Gordura**  | 0.5×| 0.5×| 2×   | 1×  | 1×   | 2×  |
| **Teoria**   | 1×  | 2×  | 0.5× | 2×  | 0.5× | 1×  |

**Legenda:**
- `2×` = super efetivo
- `0.5×` = não muito efetivo
- `0×` = sem efeito (imune)

**Resumo de imunidades:**
- **Físico** é imune a **Bug** — única imunidade total no jogo

**Descrição dos tipos:**

| Tipo | Temática |
|---|---|
| **Sistema** | Software, programação, sistemas operacionais |
| **Físico** | Hardware, componentes eletrônicos |
| **Energia** | Bebidas energéticas, eletricidade |
| **Bug** | Erros de código, vírus, glitches |
| **Gordura** | Comida do RU, vida sedentária de programador |
| **Teoria** | Disciplinas teóricas, matemática, física |

---

## 8. Entidades

### 8.1 Jogador

**Arquivo:** `FEIKemon/src/entities/Player.lua`

| Propriedade | Valor |
|---|---|
| Sprite | `assets/player/player-sheet.png` |
| Tamanho do frame | 12×18 px |
| Direções | 4 (baixo / esquerda / direita / cima) |
| Frames por direção | 4 |
| Velocidade de animação | 0.1s por frame |
| Velocidade de movimento | 80 px/s |
| Colisor | BSGRectangle 12×15 (bordas suaves) |
| Rotação física | Travada (setFixedRotation) |

**Mapeamento do spritesheet:**

```
Linha 1: animação para baixo   (frames 1-4)
Linha 2: animação para esquerda (frames 1-4)
Linha 3: animação para direita  (frames 1-4)
Linha 4: animação para cima     (frames 1-4)
```

---

### 8.2 NPCs — Professores e Staff

Todos os NPCs seguem o mesmo padrão de implementação:
- Grid de sprite: `16×32` px
- 4 frames de animação em loop (walk cycle)
- Sem lógica de update — são entidades estáticas de exibição
- Posicionados no palco da Sala de Estudos durante o Onboarding

| Personagem | Arquivo | Posição (x, y) | Linha do sprite | Observações |
|---|---|---|---|---|
| **Charles** | `Charles.png` | (-322, -155) | Linha 1 (sul) | Professor |
| **Danilo** | `Danilo.png` | (-306, -155) | Linha 1 (sul) | Narrador da intro; carrega portrait |
| **Fagner** | `Fagner.png` | (-290, -155) | Linha 1 (sul) | Prof. Fagner — mentor narrativo |
| **Leila** | `Leila.png` | (-274, -155) | Linha 2 | Prof. Leila — primeiro boss |
| **Leo** | `Leo.png` | (-258, -155) | Linha 1 (sul) | Professor |
| **Luciano** | `Luciano.png` | (-242, -155) | Linha 1 (sul) | Professor |
| **Plinio** | `Plinio.png` | (-146, -155) | Linha 1 (sul) | Separado do grupo |

**NPCs com assets prontos, aguardando implementação:**

| Personagem | Arquivo | Papel planejado |
|---|---|---|
| **Marcio** | `Marcio.png` | Mestre da FEI (Elite 4) |
| **Mauá** | `Maua.png` | Boss final |
| **Padre** | `Padre.png` | Mestre da FEI (Elite 4) |
| **Samir** | `Samir.png` | Mestre da FEI (Elite 4) |

---

## 9. FEIKemons

Todos os FEIKemons possuem dois sprites de batalha: `Frente` (visão do adversário) e `Costas` (visão do jogador). Localização: `FEIKemon/assets/PixelArtsFeiKemon/`

| # | Nome | Arquivo | Temática | Tipo(s) sugeridos |
|---|---|---|---|---|
| 01 | **C** | `CFrente.png` / `CCostas.png` | Linguagem de programação C | Sistema |
| 02 | **Iphone** | `IphoneFrente.png` / `IphoneCostas.png` | iPhone / Apple | Físico |
| 03 | **Java** | `JavaFrente.png` / `JavaCostas.png` | Linguagem Java | Sistema |
| 04 | **Linux** | `LinuxFrente.png` / `LinuxCostas.png` | Sistema operacional Linux | Sistema |
| 05 | **Monitor** | `MonitorFrente.png` / `MonitorCostas.png` | Monitor de computador | Físico |
| 06 | **Monster** | `MonsterFrente.png` / `MonsterCostas.png` | Energético Monster | Energia |
| 07 | **MonsterZero** | `MonsterZeroFrente.png` / `MonsterZeroCostas.png` | Monster Zero | Energia |
| 08 | **Mouse** | `MouseFrente.png` / `MouseCostas.png` | Mouse de computador | Físico |
| 09 | **Parmegiana** | `ParmegianaFrente.png` / `ParmegianaCostas.png` | Frango à parmegiana do RU | Gordura |
| 10 | **Python** | `PythonFrente.png` / `PythonCostas.png` | Linguagem Python | Sistema |
| 11 | **Redbull** | `RedbullFrente.png` / `RedbullCostas.png` | Energético Red Bull | Energia |
| 12 | **RedbullZero** | `RedbullZeroFrente.png` / `RedbullZeroCostas.png` | Red Bull Zero | Energia |
| 13 | **Teclado** | `TecladoFrente.png` / `TecladoCostas.png` | Teclado mecânico | Físico |
| 14 | **VR** | `VRFrente.png` / `VRCostas.png` | Óculos de realidade virtual | Físico, Energia |
| 15 | **Windows** | `WindowsFrente.png` / `WindowsCostas.png` | Sistema operacional Windows | Sistema |

**Nota:** O arquivo `Fagner.png` em `PixelArtsFeiKemon/` é usado como **portrait** do Prof. Danilo nas caixas de diálogo.

---

## 10. Mapas e Fases

### 10.1 Sala de Estudos ✅ Implementada

**Arquivo de mapa:** `FEIKemon/assets/maps/sala_de_estudos/sala_estudos.lua`  
**Classe:** `FEIKemon/src/maps/SalaDeEstudos.lua`  
**Editor:** Tiled 1.8.2 | **Exportação:** Lua

| Propriedade | Valor |
|---|---|
| Dimensões | 30×20 tiles |
| Tamanho do tile | 16×16 px |
| Tamanho total | 480×320 px |
| Número de camadas | 8 |

**Camadas do mapa (ordem de renderização, fundo ao topo):**

| Ordem | Nome da Camada | Tipo | Conteúdo |
|---|---|---|---|
| 1 | `Collision` | Object Layer | Formas invisíveis para física |
| 2 | `Ground And Walls` | Tile Layer | Chão, paredes, bordas da sala |
| 3 | `Stage` | Tile Layer | Palco elevado (área dos professores) |
| 4 | `Shadows` | Tile Layer | Sombras projetadas pelo palco |
| 5 | `Desks` | Tile Layer | Carteiras dos alunos |
| 6 | `Chairs` | Tile Layer | Cadeiras das carteiras |
| 7 | `Decoration` | Tile Layer | Plantas, enfeites, itens decorativos |
| 8 | `NPCs` | Tile Layer | Posições de referência dos NPCs |

**Tilesets utilizados:**

| Tileset | Origem | Quantidade de Tiles | Conteúdo |
|---|---|---|---|
| `bar_guss` | Stardew Valley (Spriters Resource) | 1.150 | Móveis, itens de bar |
| `ilha` | Stardew Valley | 2.336 | Tiles de exterior/ilha |
| `crafttables` | Stardew Valley | variável | Bancadas de trabalho |
| `interiors` | Stardew Valley | variável | Pisos, paredes, móveis internos |

---

## 11. Mundo e Progressão

O mapa completo do jogo representa o **campus da FEI**. Apenas a Sala de Estudos está implementada; todas as demais áreas são planejadas.

```
                    ┌─────────────────────────────────────────────┐
                    │            CAMPUS DA FEI                    │
                    │                                             │
                    │  [MacFEI de Cima]    [Sala dos Mestres]     │
                    │        │                    │               │
                    │  [Prédio K]  ←────  [Estacionamento]        │
                    │  (Ginásio 1)         dos Professores        │
                    │        │                    │               │
                    │  [Sala de Estudos] ─── [MacFEI de Baixo]    │
                    │  ✅ Implementada                            │
                    │        │                                    │
                    │  [Entrada da FEI]                           │
                    │  (ponto inicial)                            │
                    └─────────────────────────────────────────────┘
                    
                    [Capela] ← área final (Pokémon League)
```

### Equivalências com Pokémon

| Local FEI | Equivalente Pokémon | Status | Descrição |
|---|---|---|---|
| **Entrada da FEI** | Pallet Town | Planejado | Ponto de partida do calouro |
| **Sala de Estudos** | Pewter City (hub) | ✅ Implementado | Tutorial e intro narrativa |
| **Estacionamento dos Professores** | Routes (rotas) | Planejado | Área de transição, FEIKemons selvagens |
| **Prédio K** | Pewter Gym | Planejado | Ginásio 1 — Prof. Leila |
| **MacFEI de Cima** | Pokémon Center | Planejado | Cura o time do jogador |
| **MacFEI de Baixo** | Pokémon Center (penalty) | Planejado | Retorno após derrota |
| **Sala dos Mestres** | Elite Four Room | Planejado | Desafio final dos Mestres |
| **Capela** | Pokémon League | Planejado | Arena do Boss final |

---

## 12. Bosses

### Boss 1 — Prof. Leila
- **Local:** Prédio K
- **Tipo especialidade:** Teoria
- **Narrativa:** Chefe do departamento; testa os calouros nos fundamentos

### Elite 4 — Mestres da FEI
Quatro confrontos consecutivos antes do boss final:

| Mestre | Tipo especialidade | Arquivo de sprite |
|---|---|---|
| **Prof. Samir** | Sistema | `Samir.png` |
| **Padre** | Teoria | `Padre.png` |
| **Prof. Marcio** | Físico | `Marcio.png` |
| **Reitor/Staff** | — | A definir |

### Boss Final — Mauá
- **Local:** Chapel (final arena)
- **Narrativa:** Representante da Universidade Mauá (maior rival acadêmico da FEI)
- **Sprite:** `Maua.png`
- **Dificuldade:** Máxima — time completo de 6 FEIKemons de tipos variados

---

## 13. Áudio

**Localização:** `FEIKemon/assets/sounds/`

| Arquivo | Estado | Uso | Volume |
|---|---|---|---|
| `backgroundMusicStart.mp3` | ✅ Implementado | BGM do menu principal (loop) | 100% |
| `Cloud Country.mp3` | ✅ Implementado | BGM da exploração (loop) | 50% |
| `mouseClick.mp3` | ✅ Implementado | SFX de clique nos botões do menu | 100% |

**Músicas planejadas (não incluídas):**
- BGM de batalha
- Jingle de vitória
- BGM de cada área/ginásio
- SFX de captura de FEIKemon
- SFX de dano/golpe

---

## 14. UI e Estética

### Estilo Visual
- **Inspiração:** Stardew Valley (pixel art, paleta quente, tiles de interior)
- **Resolução:** Fullscreen adaptado via zoom da câmera (base 480×320 escalado)
- **Zoom:** `baseZoom * 2.5` — garante que o pixel art seja legível em telas modernas

### Fonte
- **Arquivo:** `assets/fonts/8bitoperator.ttf`
- **Tamanho:** 18px em todos os contextos de UI

### Paleta de Cores da UI

| Elemento | Cor (RGB normalizado) | Hex aproximado |
|---|---|---|
| Fundo da caixa de diálogo | `(0.85, 0.75, 0.55)` | `#D9BF8C` |
| Borda da caixa de diálogo | `(0.35, 0.22, 0.12)` | `#59381F` |
| Texto do diálogo | `(0.25, 0.15, 0.08)` | `#402614` |
| Fundo do botão do menu | `(0.3, 0.2, 0.1)` | `#4D331A` |
| Borda/texto do botão | `(1.0, 1.0, 0.0)` | `#FFFF00` |
| Fundo da tela de transição | `(0, 0, 0)` | `#000000` |
| Texto da tela de transição | `(1, 1, 1)` | `#FFFFFF` |

### Globals de Renderização

```lua
-- Variáveis globais acessíveis por todos os módulos
Cam                    -- instância da câmera
World                  -- mundo físico do windfield
TextBoxManagerGlobal   -- instância do sistema de diálogo
GamePhase              -- "Onboarding" ou "Gameplay"
```

---

## 15. Bibliotecas de Terceiros

**Localização:** `FEIKemon/src/libs/`

| Biblioteca | Arquivo(s) | Versão/Autor | Função |
|---|---|---|---|
| **anim8** | `anim8.lua` | Enrique García Cota | Sistema de animação por grid de spritesheet |
| **camera** | `camera.lua` | HUMP (Matthias Richter) | Câmera 2D com zoom, pan, attach/detach |
| **STI** | `sti/` | karai17 | Carrega e renderiza mapas do Tiled (.lua/.tmx) |
| **windfield** | `windfield/` | HDave | Wrapper simplificado do Box2D do Love2D |
| **mlib** | `windfield/mlib/` | Davis Claiborne | Biblioteca matemática (dependência do windfield) |
| **Class** | `utils/Class.lua` | HUMP (Matthias Richter) | Sistema OOP para Lua com mixins |

---

## 16. Status de Implementação

| Feature | Status | Arquivo Principal |
|---|---|---|
| **Tela de menu** (Play/Quit) | ✅ Implementado | `src/states/Menu.lua` |
| **Tela de transição narrativa** | ✅ Implementado | `src/states/Transition.lua` |
| **Mapa: Sala de Estudos** | ✅ Implementado | `src/maps/SalaDeEstudos.lua` |
| **Colisões no mapa** | ✅ Implementado | `src/maps/SalaDeEstudos.lua` |
| **Movimento do jogador** | ✅ Implementado | `src/entities/Player.lua` |
| **Animação do jogador** | ✅ Implementado | `src/entities/Player.lua` |
| **Câmera com zoom** | ✅ Implementado | `src/states/Gameplay.lua` |
| **Cena cinemática (pan)** | ✅ Implementado | `src/scenes/Onboarding.lua` |
| **NPCs na cena de intro** | ✅ Implementado | `src/scenes/Onboarding.lua` |
| **Sistema de diálogo** | ✅ Implementado | `src/utils/TextBoxManager.lua` |
| **Diálogo de intro (Danilo)** | ✅ Implementado | `src/scenes/Onboarding.lua` |
| **Pixel art dos FEIKemons** | ✅ Assets prontos | `assets/PixelArtsFeiKemon/` |
| **Sprites NPCs extras** (Marcio, Padre, Samir, Mauá) | ✅ Assets prontos | `assets/characters/` |
| **Sistema de batalha** | ❌ Não implementado | — |
| **Captura de FEIKemons** | ❌ Não implementado | — |
| **Sistema de tipos** | ❌ Não implementado | — |
| **Stats e XP dos FEIKemons** | ❌ Não implementado | — |
| **Tela de gerenciamento do time** | ❌ Não implementado | — |
| **Mapa: Prédio K** | ❌ Não implementado | — |
| **Mapa: MacFEI** | ❌ Não implementado | — |
| **Mapa: Estacionamento** | ❌ Não implementado | — |
| **Mapa: Sala dos Mestres** | ❌ Não implementado | — |
| **Mapa: Capela** | ❌ Não implementado | — |
| **Boss: Prof. Leila** | ❌ Não implementado | — |
| **Bosses: Mestres da FEI** | ❌ Não implementado | — |
| **Boss final: Mauá** | ❌ Não implementado | — |
| **Sistema de cura (MacFEI)** | ❌ Não implementado | — |
| **Progressão entre áreas** | ❌ Não implementado | — |
| **Inventário / Feikebolas** | ❌ Não implementado | — |
| **BGM de batalha e SFX** | ❌ Não implementado | — |

---

*Documentação gerada em 27/04/2026*
