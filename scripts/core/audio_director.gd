extends Node

signal music_mood_changed(mood: String)

var current_mood := "day"


func set_mood(next_mood: String) -> void:
	if current_mood == next_mood:
		return

	current_mood = next_mood
	music_mood_changed.emit(current_mood)


func play_melody(melody_id: String) -> void:
	print("Melody placeholder: ", melody_id)
