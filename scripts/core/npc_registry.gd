extends Node

signal npc_discovered(npc_id: String)
signal npc_recruited(npc_id: String)

var discovered: Dictionary = {}
var recruited: Dictionary = {}


func discover(npc_id: String, source: String = "") -> void:
	if discovered.has(npc_id):
		return

	discovered[npc_id] = {"source": source}
	npc_discovered.emit(npc_id)


func recruit(npc_id: String) -> void:
	discover(npc_id)
	if recruited.has(npc_id):
		return

	recruited[npc_id] = true
	VillageManager.register_recruit(npc_id)
	npc_recruited.emit(npc_id)


func is_recruited(npc_id: String) -> bool:
	return recruited.has(npc_id)
