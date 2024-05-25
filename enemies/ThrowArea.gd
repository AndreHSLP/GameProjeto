extends Area2D

@onready var throw_area = $"."

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var follow_player = $"../FollowPlayer"

var timer_Throw_TNT:float=0.0

var timer_cooldown:float=1.0

var throwing=false

const PATH_2D_TNT_prefab = preload("res://misc/path_2dTNT.tscn")

func _process(delta):
	timer_Throw_TNT-=delta
	if throwing and timer_Throw_TNT<0:
		throwTNT()
		timer_Throw_TNT=timer_cooldown
		return
	


	
func throwTNT():
	animated_sprite_2d.play("throw")
	timer_Throw_TNT=timer_cooldown
	var TNT = PATH_2D_TNT_prefab.instantiate()
	TNT.position=get_parent().position
	get_parent().get_parent().add_child(TNT)
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		follow_player.lock=true
		throwing=true


func _on_body_exited(body):
	if body.is_in_group("player"):
		follow_player.lock=false
		throwing=false
		animated_sprite_2d.play("walk")
