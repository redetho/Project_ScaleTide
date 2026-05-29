extends Node

signal item_changed(item_id: String, quantity: int)

var items: Dictionary = {}


func add_item(item_id: String, amount: int = 1) -> void:
	if amount <= 0:
		return

	items[item_id] = get_quantity(item_id) + amount
	item_changed.emit(item_id, items[item_id])


func remove_item(item_id: String, amount: int = 1) -> bool:
	if amount <= 0 or get_quantity(item_id) < amount:
		return false

	items[item_id] -= amount
	if items[item_id] <= 0:
		items.erase(item_id)
		item_changed.emit(item_id, 0)
	else:
		item_changed.emit(item_id, items[item_id])
	return true


func get_quantity(item_id: String) -> int:
	return int(items.get(item_id, 0))
