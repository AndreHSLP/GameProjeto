extends Node2D

const Explosion_prefab = preload("res://magic/explosion.tscn")

func create_xplosion():
	var explosion = Explosion_prefab.instantiate()
	explosion.position=position
	get_parent().add_child(explosion)
	queue_free()
