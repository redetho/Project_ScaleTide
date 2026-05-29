class_name BiomeData
extends Resource

@export var id := ""
@export var display_name := ""
@export_multiline var description := ""
@export var day_resource_tags: Array[String] = []
@export var night_resource_tags: Array[String] = []
@export var danger_level := 0
