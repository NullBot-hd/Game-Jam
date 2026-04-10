extends Node2D

@export var player_0: CharacterBody2D
@export var player_1: CharacterBody2D

@onready var camera: Camera2D = $Camera2D

@export var margin: float = 1 
@export var min_zoom: float = 3
@export var max_zoom: float = 4
@export var zoom_speed: float = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if not player_0 or not player_1:
		return
		
	camera.position = (player_0.position + player_1.position) / 2.0
	
	var distance = calcOffset()
	var distance_x = abs(distance.x)
	
	var screen_size = get_viewport_rect().size
	var target_zoom_x = screen_size.x / (distance_x + margin)
	

	target_zoom_x = clamp(target_zoom_x, min_zoom, max_zoom)
	var target_zoom = Vector2(target_zoom_x, target_zoom_x)

	camera.zoom = camera.zoom.lerp(target_zoom, zoom_speed * delta)


func calcOffset() -> Vector2:
	var vector = (player_0.position - player_1.position)
	return vector
