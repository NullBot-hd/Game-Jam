extends CharacterBody2D

const SPEED: int = 3000.0
const JUMP_VELOCITY: int = -1750.0 * 3
const ATTACK_DAMAGE: int = 10

@export var player_id: int
@export var health_bar: ProgressBar

@export var sneak_collision: CollisionShape2D
@export var normal_collision: CollisionShape2D

@export var attack_debounce: bool
var block_debounce = false
var is_sneaking: bool = false
var game_over = true
@export var is_blocking = false
var lastDirection = 1

@onready var animatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var sfx_jump: AudioStreamPlayer = $"sfx-jump"
@onready var sfx_attack: AudioStreamPlayer = $"sfx-attack"
@onready var sfx_defeat: AudioStreamPlayer = $"sfx-defeat"
@onready var sfx_block: AudioStreamPlayer = $"sfx-block"
@onready var sfx_defeat_2: AudioStreamPlayer = $"sfx-defeat2"

@export var max_health: int = 100
@export var health: int = 100:
	set(value):
		var prev_health = health
		health = clamp(value, 0, max_health)
		
		animatedSprite2D.play("dmgP" + str(player_id))
		
		health_bar.set_display_health(health)	
		
		if health == 0:
			animatedSprite2D.play("defeatP" + str(player_id))
			sfx_defeat.play()
			game_over = true
			await get_tree().create_timer(1.8).timeout
			Engine.time_scale = 0.5
			sfx_defeat_2.play()
			
			await get_tree().create_timer(4.5).timeout 
			Engine.time_scale = 1  
			game_over = false
			get_tree().reload_current_scene()
		
func _ready ():
	if player_id == 1:
		animatedSprite2D.flip_h = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 6

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
		if not attack_debounce:
			attack_debounce = true
			animatedSprite2D.play("attackOneP" + str(player_id))
			attack()
			sfx_attack.play()
			$attack_debounce.start()
	
	if(Input.is_action_just_pressed("blockP" + str(player_id))):
		if not block_debounce:
			block_debounce = true
			is_blocking = true
			animatedSprite2D.play("defenceP" + str(player_id))
			$block_debounce.start()
			$is_blocking.start()
	
	if not (animatedSprite2D.is_playing() 
	and animatedSprite2D.animation == "attackOneP0" or animatedSprite2D.animation == "attackOneP1"
	or animatedSprite2D.animation == "dmgP0" or animatedSprite2D.animation == "dmgP1" or 
	animatedSprite2D.animation == "defeatP0" or animatedSprite2D.animation == "defeatP1" or 
	is_blocking or game_over):
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
		
		if target.health and not target.is_blocking:
			target.health -= ATTACK_DAMAGE			
#		elif target.is_blocked:
		#	sfx_block.play()
		
	ray_cast.target_position.x = defaultVal

func _on_attack_debounce_timeout() -> void:
	attack_debounce = false

func _on_block_debounce_timeout() -> void:
	block_debounce = false

func _on_is_blocking_timeout() -> void:
	is_blocking = false
