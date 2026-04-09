extends CharacterBody2D

@export var playerId: int

const SPEED: int = 100.0
const JUMP_VELOCITY: int = -200.0

@onready var animatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jumpP" + str(playerId)) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("moveLeftP" + str(playerId), "moveRightP" + str(playerId))
	
	# Flips the player into the right direction
	if direction < 0:
		animatedSprite2D.flip_h = true
	elif direction > 0:
		animatedSprite2D.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Play animation	
	if is_on_floor():
		if direction == 0:
			animatedSprite2D.play("idle")
		else:
			animatedSprite2D.play("run")
	else:
		animatedSprite2D.play("jump")	
		
	move_and_slide()
