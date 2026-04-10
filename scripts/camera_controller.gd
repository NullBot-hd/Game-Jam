extends Node2D

@export var player_0: CharacterBody2D
@export var player_1: CharacterBody2D

@onready var camera: Camera2D = $Camera2D

@export var margin: float 
@export var min_zoom: float
@export var max_zoom: float 
@export var zoom_speed: float 

@export var camBoarder: int 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if not player_0 or not player_1:
		return
		
	camera.position.x = clamp((player_0.position + player_1.position).x / 2.0, -camBoarder, camBoarder)
	
	
	
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
