extends Node2D


@onready var area_2d:Area2D = $Images/Area2D

@export var damage_amount:int = 1

func deal_damage():
	var bodies=area_2d.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy=body
			enemy.damage(damage_amount)
