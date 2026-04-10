extends CharacterBody2D

const SPEED: int = 150.0
const JUMP_VELOCITY: int = -275.0
const ATTACK_DAMAGE: int = 10

@export var player_id: int
@export var health_bar: ProgressBar

@export var sneak_collision: CollisionShape2D
@export var normal_collision: CollisionShape2D

var is_sneaking: bool = false
var lastDirection = 1

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var sfx_jump: AudioStreamPlayer2D = $"sfx-jump"
@onready var sfx_attack: AudioStreamPlayer2D = $"sfx-jump/sfx-attack"



@export var max_health: int = 100
@export var health: int = 100:
	set(value):
		var prev_health = health
		health = clamp(value, 0, max_health)
		
		animatedSprite2D.play("dmgP" + str(player_id))
		
		
		health_bar.set_display_health(health)	
		
		if health == 0:
			animatedSprite2D.play("defeatP" + str(player_id))
			await get_tree().create_timer(2.0).timeout   
			queue_free()
		print(health)
		
		
func _ready ():
	if player_id == 1:
		animatedSprite2D.flip_h = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jumpP" + str(player_id)) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()


	var direction := Input.get_axis("moveLeftP" + str(player_id), "moveRightP" + str(player_id))
	
	if direction != 0:
		lastDirection = direction
	
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

	if(Input.is_action_just_pressed("attackP" + str(player_id))):
		animatedSprite2D.play("attackOneP" + str(player_id))
		attack()
		sfx_attack.play()
	print(animatedSprite2D.animation)
	if not (animatedSprite2D.is_playing() 
	and animatedSprite2D.animation == "attackOneP0" or animatedSprite2D.animation == "attackOneP1"
	or animatedSprite2D.animation == "dmgP0" or animatedSprite2D.animation == "dmgP1" or 
	animatedSprite2D.animation == "defeatP0" or animatedSprite2D.animation == "defeatP1"):
		if is_on_floor() or is_sneaking:
			if direction == 0:
				if is_sneaking:
					animatedSprite2D.play("sneakP" + str(player_id))
				else:	
					animatedSprite2D.play("idleP" + str(player_id))
			else:
				animatedSprite2D.play("runP" + str(player_id))
		else:
			animatedSprite2D.play("jumpP" + str(player_id))	

		
	# Play animation	
	
		
	move_and_slide()
	
func attack():	
	var defaultVal = ray_cast.target_position.x
	ray_cast.target_position.x *= lastDirection
	
	ray_cast.force_raycast_update()

	
	if ray_cast.is_colliding():
		var target = ray_cast.get_collider()
		
		print(str(target))
		if target.health:
			target.health -= ATTACK_DAMAGE			
		
	ray_cast.target_position.x = defaultVal
