class_name CombatDirector
extends Node

signal encounter_started(encounter_id: String)
signal encounter_completed(encounter_id: String)

var active_encounter_id := ""


func start_encounter(encounter_id: String, phase := GameState.GamePhase.COMBAT) -> void:
	if not active_encounter_id.is_empty():
		return

	active_encounter_id = encounter_id
	GameState.change_phase(phase)
	encounter_started.emit(encounter_id)


func complete_encounter() -> void:
	if active_encounter_id.is_empty():
		return

	var completed_id := active_encounter_id
	active_encounter_id = ""
	GameState.change_phase(GameState.GamePhase.EXPLORATION)
	encounter_completed.emit(completed_id)
