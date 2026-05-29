class_name BuildingData
extends Resource

@export var id := ""
@export var display_name := ""
@export_multiline var description := ""
@export var required_stage := 0
@export var required_npc_id := ""
@export var material_costs: Dictionary = {}
@export var unlock_tags: Array[String] = []
