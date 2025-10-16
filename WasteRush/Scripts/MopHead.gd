extends CharacterBody2D

const SPEED = 100.0
const R_speed = 50
var Speed = SPEED
var AttackStopped = true
var health = 100
@export var AttackAComboTime = .55
@export var JUMP_VELOCITY = -300.0
signal change_dmg(dmg)

func _ready() -> void:
	position = Globals.PlayerPos 	
	health = Globals.PlayerHealth
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 1.2	
	#Inputs Import and Set Variables
	var left: bool = Input.is_action_pressed("Left")
	var right: bool = Input.is_action_pressed("Right")
	var Sprint: bool = Input.is_action_pressed("Sprint")
	#attack animations stopped This needs priorety over most movement
	if $AttackA1.is_stopped() and $AttackA2.is_stopped():
		AttackStopped = true
	else:
		AttackStopped = false
	#if get_local_mouse_position().x < 0:
		#left = true
		#right = false
	#if get_local_mouse_position().x > 0:
		#right = true
		#left = false
	
	
	
	#Animations flip
	if left:
		$AnimatedSprite2D.flip_h = true
		$DMGbox.scale.x = -1
	if right:
		$AnimatedSprite2D.flip_h = false
		$DMGbox.scale.x = 1
		
#region Handle Sprint
	if Sprint and Globals.SprintBar > 0 and AttackStopped:
		Speed = SPEED + R_speed
		Globals.SprintBar -= 2
	else:
		Speed = SPEED
		if Globals.SprintBar < 100 and not Sprint:
			Globals.SprintBar += .125
#endregion
#region Handle Jump
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released('Jump') and  velocity.y < 0:
		velocity.y = -20
#endregion
#region Handle Animations Swapping
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * Speed
		if not is_on_floor() and AttackStopped:
			if velocity.y < 0:
				$AnimatedSprite2D.set_animation("MopHeadJump")
			else:
				$AnimatedSprite2D.set_animation("MopHeadFall")
		elif  AttackStopped:
			$AnimatedSprite2D.set_animation("MopHeadRun")
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		if not is_on_floor() and AttackStopped:
			if velocity.y < 0:
				$AnimatedSprite2D.set_animation("MopHeadJump")
			else:
				$AnimatedSprite2D.set_animation("MopHeadFall")
		elif  AttackStopped:
			$AnimatedSprite2D.set_animation("MopHeadIdle")
#endregion
	# Attack Pos Lock
	if  not AttackStopped:
		velocity.x = 0
	 
#region AttackA:mouse click and Attack Timers
	if Input.is_action_just_pressed("Attack A") and $AttackA2.is_stopped() and $AttackACombo.is_stopped():
		$AnimatedSprite2D.set_animation("MopHeadAttackA1")
		$AttackA1.start()
		change_dmg.emit(15)
		$AttackACombo.start(AttackAComboTime)
		if $AnimatedSprite2D.flip_h == true:
			velocity.x = 200
		if $AnimatedSprite2D.flip_h == false:
			velocity.x = -200
	if Input.is_action_just_pressed("Attack A") and $AttackA1.is_stopped() and $AttackA2.is_stopped() and not $AttackACombo.is_stopped():
		$AnimatedSprite2D.set_animation("MopHeadAttackA2")
		$AttackA2.start()
		change_dmg.emit(20)
		$AttackACombo.stop()
		if $AnimatedSprite2D.flip_h == true:
			velocity.x = 300
		if $AnimatedSprite2D.flip_h == false:
			velocity.x = -300
#endregion
	#HurtBoxes
	if not AttackStopped:
		$DMGbox/CollisionPolygon2D.disabled = false
	else:
		$DMGbox/CollisionPolygon2D.disabled = true
	move_and_slide()
	#Update Globals
	Globals.PlayerPos = position
	Globals.PlayerHealth = health
	
	
	if Input.is_action_just_pressed('Options'):
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
