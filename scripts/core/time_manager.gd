extends Node

signal day_started(day: int)
signal night_started(day: int)
signal hour_changed(hour: int)

const HOURS_PER_DAY := 24

@export var real_seconds_per_day := 240.0
@export var night_start_hour := 18
@export var day_start_hour := 6

var current_day := 1
var current_hour := 6
var day_progress := 0.25
var _elapsed := 0.0
var _was_daytime := true


func _ready() -> void:
	_elapsed = real_seconds_per_day * (float(day_start_hour) / HOURS_PER_DAY)
	day_progress = _elapsed / real_seconds_per_day
	current_hour = day_start_hour
	_was_daytime = is_daytime()


func _process(delta: float) -> void:
	_elapsed = fmod(_elapsed + delta, real_seconds_per_day)
	day_progress = _elapsed / real_seconds_per_day

	var next_hour := int(floor(day_progress * HOURS_PER_DAY))
	if next_hour != current_hour:
		current_hour = next_hour
		hour_changed.emit(current_hour)

	var daytime := is_daytime()
	if daytime != _was_daytime:
		_was_daytime = daytime
		if daytime:
			current_day += 1
			day_started.emit(current_day)
		else:
			night_started.emit(current_day)


func is_daytime() -> bool:
	return current_hour >= day_start_hour and current_hour < night_start_hour


func skip_to_night() -> void:
	_elapsed = real_seconds_per_day * (float(night_start_hour) / HOURS_PER_DAY)


func skip_to_day() -> void:
	_elapsed = real_seconds_per_day * (float(day_start_hour) / HOURS_PER_DAY)
