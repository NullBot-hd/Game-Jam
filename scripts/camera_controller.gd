extends Node2D

@export var player_0: CharacterBody2D
@export var player_1: CharacterBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(str(calcOffest()))
	$".".position = player_1.position + calcOffest()

func calcOffest() -> Vector2:
	var vector = .5 * (player_0.position - player_1.position)
	return vector
