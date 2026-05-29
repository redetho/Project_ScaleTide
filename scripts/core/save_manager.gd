extends Node

const SAVE_PATH := "user://sleeping_dragon_save.json"


func collect_save_data() -> Dictionary:
	return {
		"day": TimeManager.current_day,
		"hour": TimeManager.current_hour,
		"village_stage": VillageManager.current_stage,
		"buildings": VillageManager.buildings,
		"recruited_npcs": VillageManager.recruited_npcs,
		"items": InventoryManager.items
	}


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(JSON.stringify(collect_save_data(), "\t"))


func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}

	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}
