extends Area2D

@export var speed: int = 250
var direction: Vector2 = Vector2.UP
func _ready() -> void:
	$SelfDestructTimer.start()
	
	
func _process(delta):
	position += direction * speed * delta
	
	

func _on_body_entered(body):
	if "health" in body:
		body.health -= 20
		
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
