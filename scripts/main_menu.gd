extends Control

func _on_practice_button_pressed() -> void:
	var error := get_tree().change_scene_to_file("res://scenes/test_arena.tscn")
	if error != OK:
		push_error("Could not load the practice arena (error %d)." % error)
