class_name RecruitmentSystem
extends Node


func rescue_npc(npc_id: String, source_location: String) -> void:
	NPCRegistry.discover(npc_id, source_location)
	QuestManager.start_quest("recrutar_%s" % npc_id, {"npc_id": npc_id, "source": source_location})


func complete_recruitment(npc_id: String) -> void:
	NPCRegistry.recruit(npc_id)
	QuestManager.complete_quest("recrutar_%s" % npc_id)
