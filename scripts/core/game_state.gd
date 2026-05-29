extends Node

signal phase_changed(new_phase: GamePhase)

enum GamePhase {
	VILLAGE,
	EXPLORATION,
	COMBAT,
	FISSURE,
	DIALOGUE,
	MENU
}

var current_phase := GamePhase.EXPLORATION


func change_phase(next_phase: GamePhase) -> void:
	if current_phase == next_phase:
		return

	current_phase = next_phase
	phase_changed.emit(current_phase)


func phase_name() -> String:
	match current_phase:
		GamePhase.VILLAGE:
			return "Vila"
		GamePhase.EXPLORATION:
			return "Exploração"
		GamePhase.COMBAT:
			return "Combate"
		GamePhase.FISSURE:
			return "Fissura"
		GamePhase.DIALOGUE:
			return "Diálogo"
		GamePhase.MENU:
			return "Menu"
		_:
			return "Desconhecida"
