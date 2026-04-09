extends CharacterBody2D

const SPEED: int = 100.0
const JUMP_VELOCITY: int = -200.0

@export var player_id: int

@export var sneak_collision: CollisionShape2D
@export var normal_collision: CollisionShape2D

var is_sneaking: bool = false

@onready var animatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jumpP" + str(player_id)) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("moveLeftP" + str(player_id), "moveRightP" + str(player_id))
	
	if normal_collision and sneak_collision:
		if Input.is_action_just_pressed("sneakP" + str(player_id)):
			is_sneaking = true
		
		if Input.is_action_just_released("sneakP" + str(player_id)):
			is_sneaking = false
		
		if is_sneaking:
			sneak_collision.disabled = false
			normal_collision.disabled = true
		else:
			normal_collision.disabled = false
			sneak_collision.disabled = true
	
	# Flips the player into the right direction
	if direction < 0:
		animatedSprite2D.flip_h = true
		
	elif direction > 0:
		animatedSprite2D.flip_h = false
	
	if direction and not is_sneaking:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Play animation	
	if is_on_floor() or is_sneaking:
		if direction == 0:
			if is_sneaking:
				animatedSprite2D.play("sneak")
			else:	
				animatedSprite2D.play("idle")
		else:
			animatedSprite2D.play("run")
	else:
		animatedSprite2D.play("jump")	
		
	move_and_slide()
