extends Control
func _ready() -> void:
	$HScrollBar.value = Globals.CamZoom

func _process(_delta: float) -> void:
	Globals.CamZoom = $HScrollBar.value

func _on_start_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://scenes/stage_1.tscn")
	
	
func _on_save_pressed() -> void:
	Globals.save()


func _on_load_pressed() -> void:
	Globals.load_data()
	get_tree().change_scene_to_file("res://scenes/stage_1.tscn")


func _on_button_pressed() -> void:
	get_tree().quit()
