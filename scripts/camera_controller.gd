extends Node2D

@export var player_0: CharacterBody2D
@export var player_1: CharacterBody2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(str(calcOffest()))
	$".".position = calcOffest()

func calcOffest() -> Vector2:
	var vector = player_1.position + .5 * (player_0.position - player_1.position)
	return vector
