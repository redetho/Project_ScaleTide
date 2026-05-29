extends Node

signal stage_changed(stage: VillageStage)
signal building_added(building_id: String)

enum VillageStage {
	CAMP,
	SETTLEMENT,
	VILLAGE,
	FRONTIER_CITY
}

var current_stage := VillageStage.CAMP
var buildings: Array[String] = []
var recruited_npcs: Array[String] = []


func add_building(building_id: String) -> void:
	if buildings.has(building_id):
		return

	buildings.append(building_id)
	building_added.emit(building_id)
	_check_stage_progression()


func register_recruit(npc_id: String) -> void:
	if recruited_npcs.has(npc_id):
		return

	recruited_npcs.append(npc_id)
	_check_stage_progression()


func stage_name() -> String:
	match current_stage:
		VillageStage.CAMP:
			return "Acampamento"
		VillageStage.SETTLEMENT:
			return "Assentamento"
		VillageStage.VILLAGE:
			return "Vila"
		VillageStage.FRONTIER_CITY:
			return "Cidade Fronteiriça"
		_:
			return "Desconhecida"


func _check_stage_progression() -> void:
	var next_stage := current_stage
	if recruited_npcs.size() >= 2 and buildings.size() >= 3:
		next_stage = VillageStage.SETTLEMENT
	if recruited_npcs.size() >= 5 and buildings.size() >= 7:
		next_stage = VillageStage.VILLAGE
	if recruited_npcs.size() >= 9 and buildings.size() >= 12:
		next_stage = VillageStage.FRONTIER_CITY

	if next_stage != current_stage:
		current_stage = next_stage
		stage_changed.emit(current_stage)
