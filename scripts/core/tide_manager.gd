extends Node

signal tide_changed(tide_data: TideData)

const TideDataScript := preload("res://scripts/resources/tide_data.gd")

var available_tides: Array[TideData] = []
var current_tide: TideData
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	_build_default_tides()
	clear_tide()


func roll_night_tide() -> void:
	if available_tides.is_empty():
		clear_tide()
		return

	var golden_roll := rng.randf()
	if golden_roll >= 0.96:
		current_tide = _make_tide("Maré Dourada", Color(1.0, 0.78, 0.22, 0.18), ["peixes raros", "sementes luminosas"], true)
	else:
		current_tide = available_tides[rng.randi_range(0, available_tides.size() - 1)]

	tide_changed.emit(current_tide)


func clear_tide() -> void:
	current_tide = _make_tide("Sem Maré", Color(0, 0, 0, 0), [], false)
	tide_changed.emit(current_tide)


func _build_default_tides() -> void:
	available_tides = [
		_make_tide("Maré Azul", Color(0.22, 0.42, 0.95, 0.16), ["correntes de luz", "peixes aéreos"], false),
		_make_tide("Maré Verde", Color(0.28, 0.85, 0.5, 0.13), ["sementes noturnas", "ervas de bruma"], false),
		_make_tide("Maré Negra", Color(0.08, 0.02, 0.12, 0.28), ["ecos corrompidos", "fissuras ativas"], false)
	]


func _make_tide(display_name: String, overlay_color: Color, resources: Array[String], rare: bool) -> TideData:
	var data: TideData = TideDataScript.new()
	data.id = display_name.to_snake_case()
	data.display_name = display_name
	data.overlay_color = overlay_color
	data.resource_tags = resources
	data.is_rare = rare
	return data
