class_name BuildingSystem
extends Node

signal construction_started(building_id: String)
signal construction_completed(building_id: String)

var active_sites: Dictionary = {}


func can_build(_building_id: String, material_costs: Dictionary) -> bool:
	for item_id in material_costs.keys():
		if InventoryManager.get_quantity(str(item_id)) < int(material_costs[item_id]):
			return false
	return true


func start_construction(building_id: String, material_costs: Dictionary = {}) -> bool:
	if not can_build(building_id, material_costs):
		return false

	for item_id in material_costs.keys():
		InventoryManager.remove_item(str(item_id), int(material_costs[item_id]))
	active_sites[building_id] = {"day_started": TimeManager.current_day}
	construction_started.emit(building_id)
	return true


func complete_construction(building_id: String) -> void:
	if not active_sites.has(building_id):
		return

	active_sites.erase(building_id)
	VillageManager.add_building(building_id)
	construction_completed.emit(building_id)
