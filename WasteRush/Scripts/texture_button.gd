extends TextureButton

func _process(delta: float) -> void:
	if button_pressed:
		get_tree().change_scene_to_file("res://scenes/stage_1.tscn")
