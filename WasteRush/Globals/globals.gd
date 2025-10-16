extends Node

var SprintBar = 100
var CamZoom = 4
var PlayerHealth = 100
var PlayerPos: Vector2 = Vector2(550.0,480)

var save_path = "user://variable.save"

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(PlayerPos.x)
	file.store_var(PlayerPos.y)
	file.store_var(CamZoom)
	file.store_var(PlayerHealth)
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		PlayerPos.x = file.get_var(PlayerPos.x)
		PlayerPos.y = file.get_var(PlayerPos.y)
		CamZoom = file.get_var(CamZoom)
		PlayerHealth = file.get_var(PlayerHealth)
	else:
		print("no data saved")
		PlayerPos = Vector2(550,480)
		CamZoom = 4
