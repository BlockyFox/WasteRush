extends Node2D



@export var zoom: Vector2 = Vector2(Globals.CamZoom,Globals.CamZoom)

var bannana_scene: PackedScene = preload("res://scenes/Ennemies/bannana.tscn")
var garbage_scene: PackedScene = preload("res://scenes/Ennemies/garbage_bag.tscn")

func _process(_delta: float) -> void:
	zoom = Vector2(Globals.CamZoom,Globals.CamZoom)
	$Commando/Camera2D.set_zoom(zoom)
	if Input.is_action_just_pressed("RClick"):
		var garbage = garbage_scene.instantiate()
		garbage.position = $Commando.position
		
		$Ennemies.add_child(garbage)
		
		
func _on_garbage_bag_banana(pos, direction):
	var banana = bannana_scene.instantiate() as Area2D
	
	banana.direction = direction
	if direction == Vector2.LEFT:
		banana.scale.x = -.7
	print(banana.position)
	print(pos)
	print("banana")
	$Projectiles.add_child(banana)
	banana.global_position = pos
