# Lua + Love2D — O Essencial para quem já sabe programar

> Referência rápida para desenvolvedores com experiência em outras linguagens.  
> Foco em diferenças, pegadinhas e padrões do Love2D.

---

## Sumário

1. [Lua em 5 minutos](#1-lua-em-5-minutos)
2. [Variáveis e Tipos](#2-variáveis-e-tipos)
3. [Operadores](#3-operadores)
4. [Strings](#4-strings)
5. [Tabelas — a estrutura de dados universal](#5-tabelas)
6. [Controle de Fluxo](#6-controle-de-fluxo)
7. [Funções](#7-funções)
8. [OOP em Lua — Classes na mão](#8-oop-em-lua)
9. [Módulos e require](#9-módulos-e-require)
10. [Escopo e Variáveis Globais](#10-escopo-e-variáveis-globais)
11. [Love2D — Estrutura do Jogo](#11-love2d--estrutura-do-jogo)
12. [Love2D — Gráficos](#12-love2d--gráficos)
13. [Love2D — Input](#13-love2d--input)
14. [Love2D — Áudio](#14-love2d--áudio)
15. [Love2D — Física (windfield/Box2D)](#15-love2d--física)
16. [Love2D — Sistema de Arquivos](#16-love2d--sistema-de-arquivos)
17. [Padrões Comuns no FEIKemon](#17-padrões-comuns-no-feikemon)
18. [Erros Comuns e Pegadinhas](#18-erros-comuns-e-pegadinhas)
19. [Tipagem em Lua](#19-tipagem-em-lua)

---

## 1. Lua em 5 minutos

```lua
-- Comentário de linha

--[[
  Comentário
  de bloco
]]

-- Ponto e vírgula é OPCIONAL (convenção: não usar)
local x = 10
local y = 20
local soma = x + y

-- print funciona como console.log / System.out.println
print(soma)  -- 30
```

**Diferenças imediatas se você vem de C/Java/Python:**

| Conceito | Outras linguagens | Lua |
|---|---|---|
| `null` | `null` / `None` | `nil` |
| `&&` | `&&` | `and` |
| `\|\|` | `\|\|` | `or` |
| `!` | `!` | `not` |
| `!=` | `!=` | `~=` |
| Arrays | índice 0 | **índice 1** |
| `else if` | `else if` / `elif` | `elseif` (sem espaço) |
| Incremento | `i++` | `i = i + 1` (não existe `++`) |
| Tamanho de array | `.length` / `len()` | `#tabela` |

---

## 2. Variáveis e Tipos

### Declaração

```lua
local x = 10          -- local ao escopo atual (PREFIRA SEMPRE)
y = 10                -- global (evite — polui o namespace global)
```

### Tipos primitivos

```lua
local inteiro  = 42
local decimal  = 3.14
local texto    = "olá"
local booleano = true
local nada     = nil      -- equivalente ao null

-- Verificar tipo
print(type(42))        -- "number"
print(type("oi"))      -- "string"
print(type(true))      -- "boolean"
print(type(nil))       -- "nil"
print(type({}))        -- "table"
print(type(print))     -- "function"
```

### Lua tem apenas `number` — sem int/float separados

```lua
local a = 10      -- number
local b = 10.0    -- number (mesmo tipo)
local c = 10 / 3  -- 3.3333... (divisão sempre retorna float)
local d = 10 // 3 -- 3 (divisão inteira, floor division)
local e = 10 % 3  -- 1 (módulo)
```

---

## 3. Operadores

```lua
-- Aritméticos
+   -   *   /    -- soma, sub, mult, div (sempre float)
//               -- divisão inteira
%                -- módulo
^                -- potência (2^10 = 1024)

-- Comparação
==  ~=           -- igual, diferente (NÃO é !=)
<   >   <=  >=

-- Lógicos
and   or   not   -- (NÃO é && || !)

-- Concatenação de strings
..               -- "olá" .. " mundo" == "olá mundo"
print("Vida: " .. vida .. " pts")

-- Tamanho
#                -- #"hello" == 5  |  #{1,2,3} == 3
```

### Truthy / Falsy

Em Lua, **apenas `false` e `nil` são falsy**. Tudo o mais é truthy — incluindo `0` e `""`.

```lua
if 0 then print("verdadeiro") end    -- IMPRIME (diferente de C/JS!)
if "" then print("verdadeiro") end   -- IMPRIME
if nil then print("nunca") end       -- não imprime
if false then print("nunca") end     -- não imprime
```

### Operador `or` como valor padrão

```lua
-- padrão idiomático para default values:
local velocidade = config.speed or 100
-- se config.speed for nil ou false, usa 100
```

---

## 4. Strings

```lua
local s = "hello"
local s2 = 'também funciona com aspas simples'
local s3 = [[
  string
  multilinha
]]

-- Tamanho
print(#s)              -- 5

-- Concatenação
print("Oi " .. "mundo")

-- Funções da biblioteca string
string.upper("lua")           -- "LUA"
string.lower("LUA")           -- "lua"
string.len("hello")           -- 5
string.sub("hello", 2, 4)     -- "ell"  (índice 1-based!)
string.rep("ab", 3)           -- "ababab"
string.find("hello", "ell")   -- 2  4  (início, fim)
string.format("%.2f", 3.14159) -- "3.14"  (igual printf do C)

-- Atalho: métodos via : (açúcar sintático)
("hello"):upper()             -- "HELLO"
("hello"):sub(1, 3)           -- "hel"

-- Converter tipos
tostring(42)      -- "42"
tonumber("42")    -- 42
tonumber("3.14")  -- 3.14
tonumber("abc")   -- nil (não quebra, retorna nil)
```

---

## 5. Tabelas

Tabelas são a **única estrutura de dados** em Lua. Servem como arrays, dicionários, objetos, classes — tudo.

### Como array (índice começa em 1!)

```lua
local frutas = {"maçã", "banana", "uva"}

print(frutas[1])   -- "maçã"    ← índice 1, não 0!
print(frutas[2])   -- "banana"
print(#frutas)     -- 3

-- Adicionar
table.insert(frutas, "manga")       -- adiciona no fim
table.insert(frutas, 2, "kiwi")     -- insere na posição 2

-- Remover
table.remove(frutas)                -- remove o último
table.remove(frutas, 2)             -- remove da posição 2

-- Iterar array (ipairs — respeita ordem, para no primeiro nil)
for i, v in ipairs(frutas) do
    print(i, v)
end
```

### Como dicionário (hash map)

```lua
local jogador = {
    nome = "Ash",
    vida = 100,
    nivel = 5,
}

print(jogador.nome)           -- "Ash"   (açúcar sintático)
print(jogador["nome"])        -- "Ash"   (equivalente)

jogador.vida = 80             -- atualizar
jogador.inventario = {}       -- adicionar campo novo em runtime

-- Iterar dicionário (pairs — sem ordem garantida)
for chave, valor in pairs(jogador) do
    print(chave, valor)
end
```

### Tabela mista (array + dicionário)

```lua
local misto = {
    "primeiro",              -- misto[1]
    "segundo",               -- misto[2]
    nome = "FEIKemon",       -- misto["nome"]
}
-- #misto == 2  (# conta apenas a parte sequencial)
```

### Tabelas são passadas por referência

```lua
local a = {1, 2, 3}
local b = a            -- b aponta para a MESMA tabela
b[1] = 99
print(a[1])            -- 99  (a também mudou!)

-- Para copiar: precisa iterar manualmente
local c = {}
for i, v in ipairs(a) do c[i] = v end
```

---

## 6. Controle de Fluxo

### if / elseif / else

```lua
if vida > 50 then
    print("saudável")
elseif vida > 20 then      -- elseif, não else if
    print("machucado")
else
    print("crítico")
end                        -- OBRIGATÓRIO fechar com end
```

### while

```lua
local i = 0
while i < 10 do
    i = i + 1
end
```

### repeat / until (equivalente ao do-while)

```lua
local i = 0
repeat
    i = i + 1
until i >= 10       -- condição de PARADA (não de continuação)
```

### for numérico

```lua
for i = 1, 10 do          -- de 1 até 10 (inclusivo)
    print(i)
end

for i = 10, 1, -1 do      -- countdown (passo -1)
    print(i)
end

for i = 0, 1, 0.1 do      -- passo decimal
    print(i)
end
```

### for genérico (ipairs / pairs)

```lua
-- ipairs: itera array em ordem (1, 2, 3...)
for indice, valor in ipairs(tabela) do end

-- pairs: itera todos os campos (sem ordem)
for chave, valor in pairs(tabela) do end
```

### break (não existe continue em Lua padrão)

```lua
for i = 1, 100 do
    if i == 5 then break end
    print(i)
end

-- Simular continue com goto (Lua 5.2+)
for i = 1, 10 do
    if i % 2 == 0 then goto continue end
    print(i)    -- só ímpares
    ::continue::
end
```

---

## 7. Funções

```lua
-- Declaração básica
local function saudacao(nome)
    return "Olá, " .. nome
end

-- Função como variável (equivalente)
local saudacao = function(nome)
    return "Olá, " .. nome
end

-- Múltiplos retornos (MUITO usado no Love2D)
local function dividir(a, b)
    return a // b, a % b    -- retorna quociente E resto
end

local quociente, resto = dividir(10, 3)
print(quociente, resto)     -- 3   1

-- Ignorar retornos com _
local _, resto = dividir(10, 3)

-- Parâmetros variádicos
local function soma(...)
    local args = {...}      -- captura todos em uma tabela
    local total = 0
    for _, v in ipairs(args) do total = total + v end
    return total
end
print(soma(1, 2, 3, 4))    -- 10
```

### Funções de primeira classe — closures

```lua
local function criarContador(inicio)
    local count = inicio
    return function()        -- retorna uma função
        count = count + 1
        return count
    end
end

local contador = criarContador(0)
print(contador())   -- 1
print(contador())   -- 2
print(contador())   -- 3
-- 'count' é capturado pelo closure — persiste entre chamadas
```

---

## 8. OOP em Lua

Lua não tem classes nativas. OOP é construído sobre tabelas e metatables.

### Metatables — o coração do OOP

```lua
-- __index: quando acessa um campo que não existe na tabela,
-- Lua procura no metatable
local Animal = {}
Animal.__index = Animal    -- convenção padrão

function Animal.new(nome, som)
    local self = setmetatable({}, Animal)
    -- setmetatable(obj, mt): define Animal como metatable de self
    self.nome = nome
    self.som = som
    return self
end

function Animal:falar()    -- : é açúcar para (self, ...)
    print(self.nome .. " diz " .. self.som)
end

local gato = Animal.new("Tom", "miau")
gato:falar()               -- "Tom diz miau"
```

### Herança

```lua
local Cachorro = setmetatable({}, {__index = Animal})
Cachorro.__index = Cachorro

function Cachorro.new(nome)
    local self = Animal.new(nome, "au")
    return setmetatable(self, Cachorro)
end

function Cachorro:buscar()    -- método só de Cachorro
    print(self.nome .. " foi buscar!")
end

local rex = Cachorro.new("Rex")
rex:falar()     -- herdado de Animal: "Rex diz au"
rex:buscar()    -- "Rex foi buscar!"
```

### Padrão usado no FEIKemon (biblioteca Class.lua)

```lua
local Class = require "src.utils.Class"

-- Criar classe
local Player = Class {}

-- Construtor: chamado quando Player(args)
function Player:init(x, y)
    self.x = x
    self.y = y
    self.speed = 80
end

function Player:update(dt)
    self.x = self.x + self.speed * dt
end

-- Instanciar — Class usa __call, então é como chamar função
local p = Player(100, 200)
p:update(0.016)
```

### `:` vs `.` — a confusão mais comum

```lua
-- Definir com : injeta 'self' automaticamente como 1º parâmetro
function Player:update(dt)
    print(self.x)     -- self existe
end

-- Chamar com : passa a instância como 1º argumento automaticamente
p:update(0.016)
-- equivale a:
Player.update(p, 0.016)

-- ERRO clássico: definir com . e chamar com : (ou vice-versa)
function Player.update(dt)   -- sem self!
    print(self)              -- self é nil aqui
end
p:update(0.016)  -- passa p como dt, dt fica nil — bug silencioso
```

---

## 9. Módulos e require

```lua
-- Em mymodule.lua:
local M = {}

M.PI = 3.14159

function M.area(r)
    return M.PI * r * r
end

return M    -- OBRIGATÓRIO retornar o módulo

-- Em outro arquivo:
local math2 = require "mymodule"    -- sem .lua
print(math2.area(5))

-- require usa . para separar pastas:
local Player = require "src.entities.Player"
-- carrega FEIKemon/src/entities/Player.lua
```

**`require` faz cache** — chamar duas vezes retorna o mesmo módulo (não executa de novo).

---

## 10. Escopo e Variáveis Globais

```lua
-- LOCAL é o padrão correto. Sempre use local.
local x = 10           -- visível apenas neste bloco

-- GLOBAL: acessível em qualquer arquivo
y = 10                 -- evite, exceto quando intencional

-- No FEIKemon, globais intencionais:
Cam = camera.new()         -- câmera global
World = wf.newWorld(0, 0)  -- mundo físico global
GamePhase = "Onboarding"   -- fase atual global
```

**Regra de escopo:**

```lua
local x = "externo"

do                         -- bloco cria novo escopo
    local x = "interno"
    print(x)               -- "interno"
end

print(x)                   -- "externo"
```

---

## 11. Love2D — Estrutura do Jogo

O Love2D é orientado a callbacks. Você define funções globais e o framework as chama automaticamente.

```lua
-- main.lua — os 3 callbacks principais

function love.load()
    -- Executado UMA VEZ na inicialização
    -- Carregue assets, crie objetos, configure a janela aqui
    imagem = love.graphics.newImage("assets/player.png")
    som    = love.audio.newSource("assets/click.mp3", "static")
end

function love.update(dt)
    -- Executado TODO FRAME (dt = delta time em segundos)
    -- dt é o tempo desde o último frame (~0.016 a 60fps)
    -- Use dt para movimento independente de framerate:
    x = x + velocidade * dt
end

function love.draw()
    -- Executado TODO FRAME, após update
    -- APENAS desenhe aqui — não atualize estado
    love.graphics.draw(imagem, x, y)
end
```

### Callbacks de input

```lua
function love.keypressed(key)
    -- Chamado quando uma tecla é PRESSIONADA (uma vez)
    if key == "escape" then love.event.quit() end
end

function love.keyreleased(key)
    -- Chamado quando a tecla é SOLTA
end

function love.mousepressed(x, y, button)
    -- button: 1=esquerdo, 2=direito, 3=meio
end

function love.mousereleased(x, y, button) end

function love.mousemoved(x, y, dx, dy) end
```

### Configuração da janela (`conf.lua`)

```lua
-- conf.lua (opcional, na raiz do projeto)
function love.conf(t)
    t.window.title  = "FEIKemon"
    t.window.width  = 1280
    t.window.height = 720
    t.window.fullscreen = false
    t.version = "11.4"
end
```

---

## 12. Love2D — Gráficos

### Imagens

```lua
-- Carregar (faça em love.load, não em love.draw!)
local img = love.graphics.newImage("assets/player.png")

-- Desenhar
love.graphics.draw(img, x, y)

-- Com transformações (x, y, rotação, escalaX, escalaY, origemX, origemY)
love.graphics.draw(img, x, y, 0, 2, 2, img:getWidth()/2, img:getHeight()/2)
--                              ↑rot ↑sx ↑sy  ↑ox (centraliza)

-- Tamanho da imagem
img:getWidth()
img:getHeight()
```

### Cores e formas

```lua
-- Definir cor atual (r, g, b, alpha) — valores de 0 a 1
love.graphics.setColor(1, 0, 0)          -- vermelho
love.graphics.setColor(0, 1, 0, 0.5)     -- verde 50% transparente
love.graphics.setColor(1, 1, 1)          -- branco (reset)

-- Formas
love.graphics.rectangle("fill", x, y, largura, altura)
love.graphics.rectangle("line", x, y, largura, altura)
love.graphics.circle("fill", cx, cy, raio)
love.graphics.line(x1, y1, x2, y2)

-- IMPORTANTE: sempre resetar a cor depois de usar!
love.graphics.setColor(1, 1, 1, 1)   -- se não, a cor afeta as próximas draws
```

### Texto

```lua
-- Fonte padrão
love.graphics.print("Olá!", 100, 200)

-- Fonte customizada
local fonte = love.graphics.newFont("assets/fonts/8bitoperator.ttf", 18)
love.graphics.setFont(fonte)
love.graphics.print("Olá!", 100, 200)

-- Largura de um texto (útil para centralizar)
local largura = fonte:getWidth("Olá!")
```

### Transformações (push/pop)

```lua
-- Salva o estado atual de transformação
love.graphics.push()

love.graphics.translate(100, 100)  -- desloca origem
love.graphics.rotate(math.pi / 4) -- rotaciona 45°
love.graphics.scale(2, 2)          -- escala 2x

love.graphics.draw(img, 0, 0)      -- desenha na origem transformada

-- Restaura o estado anterior
love.graphics.pop()
-- após pop, as transformações acima não afetam mais nada
```

### Dimensões da janela

```lua
local w = love.graphics.getWidth()
local h = love.graphics.getHeight()
```

---

## 13. Love2D — Input

### Polling (verificação contínua — use em `update`)

```lua
-- Teclado
if love.keyboard.isDown("w") then
    y = y - velocidade * dt
end
if love.keyboard.isDown("left", "a") then  -- qualquer uma das duas
    x = x - velocidade * dt
end

-- Mouse
local mx, my = love.mouse.getPosition()
if love.mouse.isDown(1) then    -- botão esquerdo pressionado
    -- ...
end
```

### Eventos (disparo único — use nos callbacks)

```lua
-- Para ações que devem ocorrer UMA VEZ por pressionamento
function love.keypressed(key)
    if key == "return" or key == "kpenter" then
        confirmar()
    end
    if key == "escape" then
        love.event.quit()
    end
end
```

### Nomes comuns de teclas

```lua
"a" .. "z"          -- letras
"0" .. "9"          -- números
"return"            -- Enter
"space"             -- Espaço
"escape"            -- Esc
"up" "down"         -- setas
"left" "right"
"lshift" "rshift"
"lctrl" "rctrl"
"f1" .. "f12"
```

---

## 14. Love2D — Áudio

```lua
-- Carregar
-- "static": carrega tudo na memória (bom para SFX curtos)
-- "stream": lê do disco em tempo real (bom para músicas longas)
local sfx    = love.audio.newSource("assets/click.mp3", "static")
local musica = love.audio.newSource("assets/bgm.mp3", "stream")

-- Tocar
musica:setLooping(true)    -- repetir
musica:setVolume(0.5)       -- 0.0 a 1.0
musica:play()

-- Controles
musica:pause()
musica:stop()
musica:isPlaying()          -- retorna boolean

-- SFX: para tocar o mesmo SFX múltiplas vezes simultâneas:
local clone = sfx:clone()
clone:play()
```

---

## 15. Love2D — Física

O Love2D inclui Box2D nativamente (`love.physics`). O FEIKemon usa **windfield**, que é um wrapper mais simples.

### Com windfield

```lua
local wf = require "src.libs.windfield"

-- Criar mundo (gravidade x, y)
World = wf.newWorld(0, 0)   -- 0,0 = top-down sem gravidade

-- Criar colisores
local colisor = World:newRectangleCollider(x, y, largura, altura)
colisor:setType("static")   -- "static"=imóvel | "dynamic"=move | "kinematic"

-- Colisor do jogador
self.collider = World:newBSGRectangleCollider(x, y, 12, 15, 2)
-- BSG = Beveled Square-ish Rectangle (bordas chanfradas — melhor para personagens)
self.collider:setFixedRotation(true)    -- não rotaciona ao colidir

-- Mover com física
self.collider:setLinearVelocity(vx, vy)

-- Ler posição
local x, y = self.collider:getPosition()

-- Atualizar o mundo (no love.update)
World:update(dt)
```

### Colisão em mapa Tiled

```lua
-- SalaDeEstudos.lua — criar colisores para cada objeto do layer "Collision"
for _, obj in ipairs(map.layers["Collision"].objects) do
    local c = World:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
    c:setType("static")
end
```

---

## 16. Love2D — Sistema de Arquivos

```lua
-- Love2D usa um sistema de arquivos virtual (raiz = pasta do projeto)
-- Caminhos são RELATIVOS à pasta do main.lua

local img   = love.graphics.newImage("assets/player.png")
local fonte = love.graphics.newFont("assets/fonts/font.ttf", 16)
local audio = love.audio.newSource("assets/music.mp3", "stream")

-- Ler arquivo de texto
local conteudo = love.filesystem.read("config.txt")

-- Verificar se existe
love.filesystem.getInfo("savefile.dat")  -- nil se não existe
```

---

## 17. Padrões Comuns no FEIKemon

### Estrutura de uma entidade (Player, NPC)

```lua
local Class = require "src.utils.Class"
local anim8 = require "src.libs.anim8"

local Player = Class {}

function Player:init(x, y)
    -- 1. Carregar sprite
    self.sprite = love.graphics.newImage("assets/player/player-sheet.png")

    -- 2. Criar grid de animação
    local g = anim8.newGrid(12, 18, self.sprite:getWidth(), self.sprite:getHeight())

    -- 3. Definir animações
    self.animations = {
        down  = anim8.newAnimation(g('1-4', 1), 0.1),
        left  = anim8.newAnimation(g('1-4', 2), 0.1),
        right = anim8.newAnimation(g('1-4', 3), 0.1),
        up    = anim8.newAnimation(g('1-4', 4), 0.1),
    }
    self.currentAnim = self.animations.down

    -- 4. Criar colisor físico (World é global)
    self.collider = World:newBSGRectangleCollider(x, y, 12, 15, 2)
    self.collider:setFixedRotation(true)

    self.x, self.y = x, y
    self.speed = 80
end

function Player:update(dt)
    local vx, vy = 0, 0

    if love.keyboard.isDown("w") then
        vy = -self.speed
        self.currentAnim = self.animations.up
    elseif love.keyboard.isDown("s") then
        vy = self.speed
        self.currentAnim = self.animations.down
    end

    -- (similar para a/d)

    self.collider:setLinearVelocity(vx, vy)
    self.x, self.y = self.collider:getPosition()

    if vx == 0 and vy == 0 then
        self.currentAnim:gotoFrame(1)
    else
        self.currentAnim:update(dt)
    end
end

function Player:draw()
    self.currentAnim:draw(self.sprite, self.x - 6, self.y - 9)
    -- subtrai metade do frame para centralizar na posição do colisor
end

return Player
```

### Estrutura de um state (Menu, Gameplay)

```lua
-- src/states/Menu.lua
local Menu = {}

function Menu.load()
    Menu.bg = love.graphics.newImage("assets/images/BackgroundInicial.png")
    Menu.music = love.audio.newSource("assets/sounds/bgm.mp3", "stream")
    Menu.music:setLooping(true)
    Menu.music:play()
end

function Menu.update(dt)
    -- lógica de update
end

function Menu.draw()
    love.graphics.draw(Menu.bg, 0, 0)
    -- botões, textos, etc.
end

function Menu.keypressed(key) end

function Menu.mousepressed(x, y, button)
    -- verificar clique nos botões
end

return Menu
```

### Câmera com world-space e screen-space

```lua
function Gameplay.draw()
    -- WORLD SPACE: tudo que existe no mundo do jogo
    Cam:attach()
        mapaInstance:draw()
        playerInstance:draw()
        for _, npc in ipairs(npcs) do npc:draw() end
    Cam:detach()

    -- SCREEN SPACE: UI (HUD, diálogos) — fixo na tela
    TextBoxManagerGlobal:draw()
    -- botões, vida, minimap, etc.
end
```

### Delta time — movimento correto

```lua
-- ERRADO: velocidade depende do framerate
x = x + 5

-- CORRETO: velocidade independente de framerate
x = x + velocidade * dt
-- a 60fps: dt ≈ 0.016  →  x += 80 * 0.016 = 1.28 por frame
-- a 30fps: dt ≈ 0.033  →  x += 80 * 0.033 = 2.64 por frame
-- resultado: mesma distância por segundo em qualquer framerate
```

---

## 18. Erros Comuns e Pegadinhas

### 1. Índice começa em 1

```lua
local t = {10, 20, 30}
print(t[0])   -- nil  (não é erro, mas não é o que você quer)
print(t[1])   -- 10   ← correto
```

### 2. `~=` é diferente, não `!=`

```lua
if x != 5 then   -- ERRO de sintaxe
if x ~= 5 then   -- correto
```

### 3. `and`/`or`/`not` em vez de `&&`/`||`/`!`

```lua
if x > 0 && y > 0 then   -- ERRO
if x > 0 and y > 0 then  -- correto
```

### 4. Esquecer o `end`

```lua
-- Todo if, for, while, function precisa de end
if condicao then
    faca()
end   -- ← obrigatório

for i = 1, 10 do
    print(i)
end   -- ← obrigatório

function foo()
    return 1
end   -- ← obrigatório
```

### 5. `elseif` é uma palavra só

```lua
if a then
    ...
else if b then   -- ERRADO: cria if aninhado, precisa de end extra
    ...
end
end

if a then
    ...
elseif b then    -- CORRETO
    ...
end
```

### 6. Variável não declarada = global silenciosa

```lua
function Player:init()
    velocidade = 80    -- global! bug silencioso
    local velocidade = 80  -- correto
end
```

### 7. `:` vs `.` em métodos

```lua
-- Definir com : → self é injetado como primeiro parâmetro
function Player:update(dt) ... end

-- Chamar com : → instância é passada como self
player:update(dt)      -- correto
Player.update(dt)      -- ERRADO: dt vai para self, sem dt real
```

### 8. Comparar tabelas compara referência, não valor

```lua
local a = {1, 2, 3}
local b = {1, 2, 3}
print(a == b)    -- false! (são tabelas diferentes na memória)

local c = a
print(a == c)    -- true (mesma referência)
```

### 9. `#` pode ser imprevisível em tabelas com buracos

```lua
local t = {1, 2, nil, 4}
print(#t)   -- pode retornar 2 ou 4 (comportamento indefinido)
-- Use tabelas sem buracos, ou controle o tamanho manualmente
```

### 10. Carregar assets em `draw()` causa lentidão

```lua
-- ERRADO: carrega a imagem todo frame (60x por segundo!)
function love.draw()
    local img = love.graphics.newImage("player.png")
    love.graphics.draw(img, x, y)
end

-- CORRETO: carrega uma vez em load()
function love.load()
    img = love.graphics.newImage("player.png")
end
function love.draw()
    love.graphics.draw(img, x, y)
end
```

### 11. Cor afeta todos os draws posteriores

```lua
love.graphics.setColor(1, 0, 0)      -- vermelho
love.graphics.draw(imgInimigo, x, y) -- vermelho ✓
love.graphics.draw(imgJogador, x, y) -- TAMBÉM vermelho! bug

-- SEMPRE resete após usar
love.graphics.setColor(1, 0, 0)
love.graphics.draw(imgInimigo, x, y)
love.graphics.setColor(1, 1, 1, 1)   -- reset para branco opaco
love.graphics.draw(imgJogador, x, y) -- normal ✓
```

---

---

## 19. Tipagem em Lua

### Resposta curta: não existe tipagem estática nativa em Lua

Lua é **dinamicamente tipada** — variáveis não têm tipo, apenas os **valores** têm. Uma variável pode segurar qualquer tipo em qualquer momento:

```lua
local x = 42        -- x tem um number
x = "hello"         -- agora x tem uma string (válido, sem erro)
x = true            -- agora x tem um boolean
x = nil             -- agora x não tem nada
```

Não há verificação de tipos em tempo de compilação. Erros de tipo só aparecem **em runtime**, quando o código executa.

```lua
local function soma(a, b)
    return a + b
end

soma(1, 2)        -- 3, ok
soma(1, "dois")   -- ERRO em runtime: attempt to perform arithmetic on a string value
soma(1, nil)      -- ERRO em runtime: attempt to perform arithmetic on a nil value
```

---

### O que Lua oferece nativamente: `type()`

A única ferramenta nativa de introspecção de tipo é a função `type()`:

```lua
type(42)          -- "number"
type("oi")        -- "string"
type(true)        -- "boolean"
type(nil)         -- "nil"
type({})          -- "table"
type(print)       -- "function"
```

Você pode usá-la para validação manual (guard clauses):

```lua
local function soma(a, b)
    assert(type(a) == "number", "a deve ser number, recebeu: " .. type(a))
    assert(type(b) == "number", "b deve ser number, recebeu: " .. type(b))
    return a + b
end

soma(1, "dois")
-- ERRO: a deve ser number, recebeu: string  (mensagem clara)
```

`assert(condicao, mensagem)` — se a condição for falsa/nil, lança erro com a mensagem.

---

### Coerção automática (pegadinha)

Lua faz **coerção automática** entre string e number em operações aritméticas:

```lua
print("10" + 5)     -- 15   (string "10" virou number)
print("10" * 2)     -- 20
print("10" .. 5)    -- "105" (number 5 virou string)

-- Mas não em comparações:
print("10" == 10)   -- false (tipos diferentes, sem coerção)
```

Isso pode mascarar bugs — evite misturar tipos intencionalmente.

---

### Solução moderna: LuaLS + EmmyDoc annotations

O **LuaLS** (Lua Language Server) é um servidor de linguagem que adiciona **type checking estático** via comentários de anotação no estilo EmmyDoc. É o padrão de facto para Lua moderno e tem suporte nativo no VS Code.

**Instalar no VS Code:**
1. Extensão: `sumneko.lua` (Lua Language Server)
2. Zero configuração necessária para uso básico

---

#### Anotar tipos de variáveis

```lua
---@type number
local vida = 100

---@type string
local nome = "Ash"

---@type boolean
local ativo = true

---@type table
local inventario = {}
```

---

#### Anotar funções (parâmetros e retorno)

```lua
---@param x number
---@param y number
---@return number
local function soma(x, y)
    return x + y
end

-- Com múltiplos retornos:
---@param a number
---@param b number
---@return number, number
local function dividir(a, b)
    return a // b, a % b
end

-- Com parâmetro opcional:
---@param velocidade number
---@param dt number
---@param multiplicador? number  -- ? = opcional
local function mover(velocidade, dt, multiplicador)
    multiplicador = multiplicador or 1
    return velocidade * dt * multiplicador
end
```

---

#### Definir tipos customizados (como structs/interfaces)

```lua
---@class Jogador
---@field nome string
---@field vida number
---@field nivel number
---@field feikemons table

---@type Jogador
local jogador = {
    nome = "Ash",
    vida = 100,
    nivel = 1,
    feikemons = {},
}

-- O LuaLS vai avisar se você acessar um campo que não existe na classe
jogador.vidaa = 50   -- warning: campo desconhecido
```

---

#### Anotar classes OOP (padrão do FEIKemon)

```lua
---@class Player
---@field x number
---@field y number
---@field speed number
---@field sprite love.Image
---@field collider table
local Player = Class {}

---@param x number
---@param y number
function Player:init(x, y)
    self.x = x
    self.y = y
    self.speed = 80
end

---@param dt number
function Player:update(dt)
    -- LuaLS sabe que self.x é number e self.speed é number
    -- vai dar warning se você fizer self.x + "string"
end
```

---

#### Anotar tipos de tabelas (arrays e dicionários)

```lua
-- Array de numbers
---@type number[]
local pontuacoes = {100, 200, 300}

-- Array de objetos customizados
---@type Jogador[]
local jogadores = {}

-- Dicionário string → number
---@type table<string, number>
local stats = { ataque = 50, defesa = 30 }

-- Dicionário string → função
---@type table<string, fun(dt: number)>
local callbacks = {}
```

---

#### Anotar tipos de funções

```lua
-- Tipo de uma função como parâmetro (callback)
---@param callback fun(x: number, y: number): boolean
local function executar(callback)
    return callback(10, 20)
end

-- Tipo de uma função sem retorno
---@param onDeath fun()
local function setDeathCallback(onDeath)
    onDeath()
end
```

---

#### Importar tipos de outros arquivos

```lua
-- Player.lua
---@class Player
local Player = Class {}
return Player

-- Gameplay.lua
---@type Player
local PlayerInstance = require "src.entities.Player"
-- LuaLS reconhece o tipo Player e autocompleta os campos
```

---

### Resumo: Lua tem tipo ou não?

| Característica | Lua nativo | Com LuaLS + Annotations |
|---|:---:|:---:|
| Checagem em tempo de execução | ✅ `type()` + `assert` | ✅ |
| Checagem em tempo de compilação | ❌ | ✅ (via LSP) |
| Autocompletar campos de objetos | ❌ | ✅ |
| Inferência de tipo | ❌ | ✅ (parcial) |
| Erros de tipo no editor | ❌ | ✅ |
| Coerção automática string↔number | ✅ (cuidado!) | ✅ (com warnings) |
| Genéricos | ❌ | ✅ (`table<K, V>`) |

**Recomendação prática:** use anotações `---@param` e `---@return` pelo menos nas funções públicas dos seus módulos. O investimento é mínimo e o autocompletar melhora muito o desenvolvimento.

---

*Referência criada em 27/04/2026 — baseada em Lua 5.1 (versão usada pelo Love2D 11.x)*
