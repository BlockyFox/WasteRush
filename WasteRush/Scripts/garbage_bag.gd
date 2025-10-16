#GarbageBag's Script
extends CharacterBody2D

@export var GBspeed : int = 5000
const GBJumpVelocity = -250.0
var left = false
signal banana(pos, direction)
var health = 35

#region Detect Player
var InPRange: bool = false
func _on_area_2d_body_entered(_body: Node2D) -> void:
	InPRange = true
func _on_area_2d_body_exited(_body: Node2D) -> void:
	InPRange = false
#endregion

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	 #Handle jumps.
	if $"Jump Detector".has_overlapping_bodies() and Globals.PlayerPos.y < position.y - 15 and not $"Head Protection".has_overlapping_bodies():
		if is_on_floor():
				velocity.y = GBJumpVelocity
	$ProgressBar.value = health
	if health <= 0:
		queue_free()
	
#region Handle Hops
	if not $right.has_overlapping_bodies() and left and Globals.PlayerPos.y < position.y: 
		if is_on_floor():
				velocity.y = GBJumpVelocity
	if not $left.has_overlapping_bodies() and not left and Globals.PlayerPos.y < position.y: 
		if is_on_floor():
				velocity.y = GBJumpVelocity
#endregion
#region Handle Velocity&Anim
	var direction := (Globals.PlayerPos - position).normalized()
	if direction.x:
		$AnimatedSprite2D.flip_h = true
		if InPRange :
			velocity.x = direction.x * GBspeed * delta
			$AnimatedSprite2D.set_animation("GarbageBagRun")
			if direction.x > 0:
				left = true
			if direction.x < 0:
				left = false
		elif not InPRange and velocity.x > 0 :
			$AnimatedSprite2D.set_animation("GarbageBagIdle")
			velocity.x -= 2
		elif velocity.x < 0 :
			velocity.x = 0
		elif velocity.x == 0 :
			$AnimatedSprite2D.set_animation("GarbageBagIdle")
			
	if left and not $"Stop Spin".has_overlapping_bodies():
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true
		#endregion
	if $GBAttackTimer.is_stopped():
		GBAttack()
	move_and_slide()

func _on_attack_detector_body_entered(body: Node2D) -> void:
	$GBAttackTimer.start()
	print(body)
	
func GBAttack():
	var direction = (Globals.PlayerPos.x - $".".position.x)
	if direction < 0 :
		if $"Attack Detector".has_overlapping_bodies() and $GBAttackTimer.time_left == 0:
			$GBAttackTimer.start()
			print("left")
			banana.emit(to_global($"L_R Attack/left".position), Vector2.LEFT)
	if direction > 0:
		if $"Attack Detector".has_overlapping_bodies() and $GBAttackTimer.time_left == 0:
			$GBAttackTimer.start()
			print("right")
			banana.emit(to_global($"L_R Attack/right".position), Vector2.RIGHT)
			
#func shoot(dir):
	#if dir == $"L_R Attack/left".position:
		#banana.emit(dir, Vector2.LEFT)
		#print('shotL')
	#if dir == $"L_R Attack/right".position:
		#print('shotR')
		#banana.emit(dir, Vector2.RIGHT)
