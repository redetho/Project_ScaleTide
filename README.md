# Canções do Dragão Adormecido

Bare bones de um RPG cozy top-down cooperativo em Godot 4.

## Estado atual

- Cena principal 3D em `res://scenes/main.tscn`
- Protótipo focado no Player1, com gameplay em plano X/Z e pulo real no eixo Y
  - `WASD` para mover
  - `E` para interagir
  - `Q` para tocar melodia
  - `Shift` para rolar/dash
  - `Space` para pular
  - Clique esquerdo para atacar
  - Ataque durante/logo depois de dash vira um golpe em linha mais longo, com recuperacao maior
  - Segurar `Shift` depois do dash faz o Player1 correr e soltar particulas pelos pes
- Câmera ortográfica 3D seguindo apenas o Player1
- Cenário 3D simples com chão, plataformas, rampa, Fissura, Zona Calma e Corrente de Luz
- Ciclo dia/noite em `TimeManager`
- Marés noturnas em `TideManager`
- HUD simples com fase, estágio da vila e maré atual
- Pontos de interação no mundo:
  - Acampamento
  - Zona Calma
  - Fissura do Dragão
  - Corrente de Luz
- Esqueleto de sistemas para vila, NPCs, inventário, construção, exploração, combate, ecos, loja e melodias

## Arquitetura

### Autoloads

Os singletons ficam em `res://scripts/core/`:

- `GameState`: fase atual do jogo
- `TimeManager`: dia, noite e progresso do ciclo
- `TideManager`: marés mágicas noturnas
- `VillageManager`: estágio da vila, prédios e NPCs recrutados
- `NPCRegistry`: descoberta e recrutamento
- `QuestManager`: quests simples
- `InventoryManager`: itens por quantidade
- `SaveManager`: coleta/salva dados principais
- `AudioDirector`: ponto central para música e melodias
- `CoopManager`: jogadores ativos

### Resources

Definições editáveis ficam em `res://scripts/resources/`:

- `ItemData`
- `NPCData`
- `BuildingData`
- `RecipeData`
- `MelodyData`
- `TideData`
- `BiomeData`
- `CareerData`

Use esses Resources depois para criar dados em `res://data/`, sem prender conteúdo em scripts.

### Systems

Sistemas de gameplay ficam em `res://scripts/systems/`:

- `MelodySystem`
- `EchoSystem`
- `ExplorationSystem`
- `RecruitmentSystem`
- `BuildingSystem`
- `CombatDirector`
- `ShopSystem`

Eles ainda são esqueletos, mas já têm sinais e métodos básicos para crescer.

## Próximos passos sugeridos

1. Trocar os blocos 3D de protótipo por uma cena de terreno pixelada/low-poly.
2. Transformar os pontos de interação em cenas próprias.
3. Adicionar `data/*.tres` para itens, NPCs, prédios, melodias e marés.
4. Implementar hitbox e alvo real para o ataque do Player1.
5. Refinar plataformas, rampas, bordas escaláveis e checagem de altura.
6. Implementar uma interação real no acampamento: entregar recursos, recrutar NPCs e construir.
7. Criar a primeira Fissura do Dragão como evento noturno jogável.
