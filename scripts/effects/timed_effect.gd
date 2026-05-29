class_name TimedEffect
extends Node3D

@export var lifetime := 0.24
@export var start_scale := Vector3.ONE
@export var end_scale := Vector3.ONE


func _ready() -> void:
	scale = start_scale
	var tween := create_tween()
	tween.tween_property(self, "scale", end_scale, lifetime)
	tween.tween_callback(queue_free)
