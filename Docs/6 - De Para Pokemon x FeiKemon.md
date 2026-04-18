# DE/PARA - Pokemon x FeiKemon

Este documento traduz os principais elementos da franquia Pokemon para a solucao FeiKemon, com base em toda a documentacao de projeto (Introducao, Publico Alvo, Estetica, Dinamica, Mecanica, GDD 1 pagina, GDD 10 paginas e prototipos).

## 1) Conceito e fantasia

| Pokemon (origem)                             | FeiKemon (solucao)                                                                |
| -------------------------------------------- | --------------------------------------------------------------------------------- |
| Jornada para ser mestre Pokemon              | Jornada do calouro para conhecer a FEI e salvar a faculdade da influencia da Maua |
| Regioes e cidades ficticias                  | Campus da FEI (SBC) com areas reais reinterpretadas                               |
| Rivalidade entre treinadores e equipes vilas | Conflito FEI x Maua (professores/NPCs sob influencia)                             |
| Progresso por ginasios e liga                | Progresso por derrotar Professora Leila, Mestres da FEI e boss final da Maua      |

## 2) Avatar, NPCs e papeis narrativos

| Pokemon (origem)                       | FeiKemon (solucao)                                                                     |
| -------------------------------------- | -------------------------------------------------------------------------------------- |
| Protagonista treinador                 | Calouro (aluno novo)                                                                   |
| Professor inicial (ex.: Professor Oak) | Professor Fagner (mentor principal)                                                    |
| Lider de ginasio                       | Professora Leila (chefe de departamento / primeiro boss maior)                         |
| Elite Four / campeao                   | Mestres da FEI (Reitoria, Padre, Professor Samir) + confronto final com mestre da Maua |
| Treinadores comuns                     | Professores e alunos NPCs desafiaveis                                                  |
| NPC de orientacao local                | Marcio na recepcao                                                                     |

## 3) Criaturas, tipos e progressao

| Pokemon (origem)                   | FeiKemon (solucao)                                |
| ---------------------------------- | ------------------------------------------------- |
| Pokemon                            | FeiKemon                                          |
| Tipos elementais (agua, fogo etc.) | Tipagens baseadas em materias/temas da computacao |
| Evolucao por nivel/condicoes       | Evolucao de poder por nivel (treino em batalhas)  |
| Equipe com ate 6 Pokemon           | Equipe com ate 6 FeiKemons                        |

## 4) Loop de gameplay

| Pokemon (origem)                                 | FeiKemon (solucao)                                                         |
| ------------------------------------------------ | -------------------------------------------------------------------------- |
| Explorar mapa + batalhar + capturar + treinar    | Mesmo loop central, em mapas da FEI                                        |
| Batalhas em turno                                | Batalhas em turno                                                          |
| Encontro aleatorio em grama/caverna              | Encontro aleatorio em areas externas da FEI                                |
| Batalha ao entrar no campo de visao de treinador | Batalha ao passar em frente de NPC enfrentavel                             |
| Condicao de derrota: time nocauteado             | Condicao de derrota: todos os FeiKemons derrotados                         |
| Vitoria final da jornada                         | Vitoria apos derrotar os chefes finais e concluir introducao (certificado) |

## 5) Itens, captura e cura

| Pokemon (origem)              | FeiKemon (solucao)                                          |
| ----------------------------- | ----------------------------------------------------------- |
| Pokebola                      | Feikebola                                                   |
| Captura de Pokemon selvagem   | Captura apenas de FeiKemon sem treinador (apos enfraquecer) |
| Pokemon Center                | MacFEI de cima (cura do time)                               |
| "Desmaiar e voltar ao centro" | Derrota leva o jogador ao MacFEI de baixo para recuperacao  |

## 6) Espacos e mapas (equivalencia funcional)

| Pokemon (origem)                  | FeiKemon (solucao)                         |
| --------------------------------- | ------------------------------------------ |
| Cidade inicial / ponto de partida | Entrada da FEI                             |
| Hub com NPCs de progresso         | Sala de estudos                            |
| Rotas de ligacao entre regioes    | Estacionamento dos professores             |
| Ginasio / area de boss            | Predio K (inclui luta da Professora Leila) |
| Liga Pokemon / area final         | Capela + Sala dos Mestres da FEI           |
| Centro de recuperacao recorrente  | MacFEI de cima                             |

## 7) Interface, comandos e UX

| Pokemon (origem)                               | FeiKemon (solucao)                            |
| ---------------------------------------------- | --------------------------------------------- |
| D-pad para navegar no mundo e menus            | A/W/S/D para mover jogador e seletor          |
| Botao A para confirmar/interagir               | Barra de espaco para confirmar/interagir      |
| Menus de batalha com opcoes (Lutar/Fugir etc.) | Menus de batalha com Atacar, Fugir e Capturar |
| Selecao de golpes por cursor                   | Selecao de golpes por movimentacao do seletor |

## 8) Estetica e audio

| Pokemon (origem)              | FeiKemon (solucao)                                                                      |
| ----------------------------- | --------------------------------------------------------------------------------------- |
| Pixel art propria da franquia | Pixel art inspirada em Stardew Valley                                                   |
| Trilha dinamica por contexto  | Musicas calmas na exploracao, intensas em batalha e misteriosas em momentos de historia |
| SFX de menu, dialogo e golpe  | SFX de clique, interacao com NPC e golpes/cura                                          |

## 9) Regras equivalentes (resumo de design)

1. So pode acessar certas areas apos vitorias-chave (gating por progresso).
2. Time limitado a 6 FeiKemons.
3. Nao pode capturar FeiKemon de treinadores.
4. Batalhas em turno como sistema principal.
5. Cura recorrente no MacFEI como pilar de continuidade.

## 10) DE/PARA de termos (glossario rapido)

| Termo Pokemon        | Termo FeiKemon                             |
| -------------------- | ------------------------------------------ |
| Pokemon              | FeiKemon                                   |
| Treinador            | Aluno/treinador do campus                  |
| Professor Pokemon    | Professor Fagner (mentor)                  |
| Lider de ginasio     | Professora Leila                           |
| Elite Four           | Mestres da FEI                             |
| Campeao              | Boss final associado a Maua (apos Mestres) |
| Pokebola             | Feikebola                                  |
| Pokemon Center       | MacFEI                                     |
| Regiao/rota          | Campus/areas da FEI                        |
| Batalha de treinador | Batalha contra professor/aluno             |

## 11) Pontos para alinhar no time (importante)

A documentacao atual tem pequenas variacoes entre arquivos. Para evitar retrabalho, recomenda-se padronizar:

1. Estrutura final de chefes: alguns textos falam em "Elite 4" com composicao diferente, outros em 3 Mestres da FEI + boss da Maua.
2. Fluxo de derrota: um arquivo cita retorno ao MacFEI de baixo, outro descreve MacFEI de cima como ponto central de cura.
3. Terminologia de fim de jogo: "campeao da FEI" versus "mestre da Maua" como ultimo confronto.

Se o time validar estes 3 itens, este DE/PARA pode virar base oficial para roteiro, implementacao e UX writing.
