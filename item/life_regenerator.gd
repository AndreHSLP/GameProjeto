extends Node2D

@export var regenerator_amout: int = 10

@onready var area_2d:Area2D = $Area2D



func _on_area_2d_body_entered(body):
	
	if body.is_in_group("player"):
		var player:Player=body
		player.heal(regenerator_amout)
		player.meat_collected.emit(regenerator_amout)
		queue_free()
	pass # Replace with function body.
