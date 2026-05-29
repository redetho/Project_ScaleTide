class_name ExplorationSystem
extends Node

signal location_discovered(location_id: String)
signal route_opened(route_id: String)

var discovered_locations: Dictionary = {}
var opened_routes: Dictionary = {}


func discover_location(location_id: String, tags: Array[String] = []) -> void:
	if discovered_locations.has(location_id):
		return

	discovered_locations[location_id] = {"tags": tags, "day": TimeManager.current_day}
	location_discovered.emit(location_id)


func open_route(route_id: String, from_location: String, to_location: String) -> void:
	if opened_routes.has(route_id):
		return

	opened_routes[route_id] = {"from": from_location, "to": to_location}
	route_opened.emit(route_id)
