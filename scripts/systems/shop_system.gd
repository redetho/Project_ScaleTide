class_name ShopSystem
extends Node

signal item_sold(item_id: String, amount: int, value: int)
signal shop_style_changed(style_tag: String)

var sold_tags: Dictionary = {}
var coins_earned := 0


func sell_item(item_id: String, amount: int, value_each: int, tags: Array[String] = []) -> bool:
	if not InventoryManager.remove_item(item_id, amount):
		return false

	var value := amount * value_each
	coins_earned += value
	InventoryManager.add_item("moedas", value)
	for tag in tags:
		sold_tags[tag] = int(sold_tags.get(tag, 0)) + amount
		if int(sold_tags[tag]) == 10:
			shop_style_changed.emit(tag)
	item_sold.emit(item_id, amount, value)
	return true
