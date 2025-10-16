extends CanvasLayer




func _process(_delta: float) -> void:
	$Sprint_Bar.value = Globals.SprintBar
	$HealthBar.value = Globals.PlayerHealth
	
