class_name MelodySystem
extends Node

signal melody_performed(melody_id: String, performer: Node)


func perform_melody(melody_id: String, performer: Node, context: Dictionary = {}) -> void:
	AudioDirector.play_melody(melody_id)
	InventoryManager.add_item("eco_%s" % melody_id, 1)
	melody_performed.emit(melody_id, performer)
	if context.has("quest_id"):
		QuestManager.start_quest(str(context["quest_id"]), context)
