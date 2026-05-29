# Project ScaleTide

Bare bones de um RPG cozy top-down/2.5D cooperativo em Godot 4.

## Estado Atual

- Cena principal 3D em `res://scenes/main.tscn`
- Prototipo focado no Player1, com gameplay em plano X/Z e pulo real no eixo Y
  - `WASD` para mover
  - `E` para interagir
  - `Q` para tocar melodia
  - `Shift` para rolar/dash
  - `Space` para pular
  - Clique esquerdo para atacar
  - Ataque durante/logo depois de dash vira um golpe em linha mais longo, com recuperacao maior
  - Segurar `Shift` depois do dash faz o Player1 correr e soltar particulas pelos pes
- Camera ortografica 3D seguindo apenas o Player1
- Cenario 3D simples com chao, plataformas, rampa, Fissura, Zona Calma e Corrente de Luz
- Ciclo dia/noite em `TimeManager`
- Mares noturnas em `TideManager`
- HUD simples com fase, estagio da vila e mare atual
- GDD inicial em `GDD.md`

## Arquitetura

### Autoloads

Os singletons ficam em `res://scripts/core/`:

- `GameState`: fase atual do jogo
- `TimeManager`: dia, noite e progresso do ciclo
- `TideManager`: mares magicas noturnas
- `VillageManager`: estagio da vila, predios e NPCs recrutados
- `NPCRegistry`: descoberta e recrutamento
- `QuestManager`: quests simples
- `InventoryManager`: itens por quantidade
- `SaveManager`: coleta/salva dados principais
- `AudioDirector`: ponto central para musica e melodias
- `CoopManager`: jogadores ativos

### Resources

Definicoes editaveis ficam em `res://scripts/resources/`:

- `ItemData`
- `NPCData`
- `BuildingData`
- `RecipeData`
- `MelodyData`
- `TideData`
- `BiomeData`
- `CareerData`

### Systems

Sistemas de gameplay ficam em `res://scripts/systems/`:

- `MelodySystem`
- `EchoSystem`
- `ExplorationSystem`
- `RecruitmentSystem`
- `BuildingSystem`
- `CombatDirector`
- `ShopSystem`

### Effects

Prefabs editaveis ficam em `res://scenes/effects/`:

- `player_shadow.tscn`
- `dash_effect.tscn`
- `run_trail_effect.tscn`
- `attack_effect.tscn`
- `dash_attack_effect.tscn`

## Proximos Passos Sugeridos

1. Trocar os blocos 3D de prototipo por uma cena de terreno pixelada/low-poly.
2. Transformar os pontos de interacao em cenas proprias.
3. Adicionar `data/*.tres` para itens, NPCs, predios, melodias e mares.
4. Implementar hitbox e alvo real para o ataque do Player1.
5. Refinar plataformas, rampas, bordas escalaveis e checagem de altura.
6. Implementar uma interacao real no acampamento: entregar recursos, recrutar NPCs e construir.
7. Criar a primeira Fissura do Dragao como evento noturno jogavel.
