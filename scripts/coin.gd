extends Area2D

@onready var gameManager: Node = %GameManager
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
 
func _on_body_entered(body: Node2D) -> void:		
	gameManager.add_point()
	animationPlayer.play("pickup")
