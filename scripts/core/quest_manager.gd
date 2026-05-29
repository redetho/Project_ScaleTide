extends Node

signal quest_started(quest_id: String)
signal quest_completed(quest_id: String)

var active_quests: Dictionary = {}
var completed_quests: Dictionary = {}


func start_quest(quest_id: String, context: Dictionary = {}) -> void:
	if active_quests.has(quest_id) or completed_quests.has(quest_id):
		return

	active_quests[quest_id] = context
	quest_started.emit(quest_id)


func complete_quest(quest_id: String) -> void:
	if not active_quests.has(quest_id):
		return

	completed_quests[quest_id] = active_quests[quest_id]
	active_quests.erase(quest_id)
	quest_completed.emit(quest_id)
