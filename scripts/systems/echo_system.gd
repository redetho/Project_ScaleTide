class_name EchoSystem
extends Node

signal echo_recorded(echo_id: String)

var echoes: Array[Dictionary] = []


func record_echo(melody_id: String, position: Vector2, strength: float = 1.0) -> void:
	var echo_id := "%s_%d" % [melody_id, echoes.size()]
	echoes.append({
		"id": echo_id,
		"melody_id": melody_id,
		"position": position,
		"strength": strength,
		"day": TimeManager.current_day
	})
	echo_recorded.emit(echo_id)
