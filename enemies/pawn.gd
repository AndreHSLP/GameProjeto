extends Node

@export var speed: float = 1
var input_vec

var enemy:Enemy
@onready var sprite = $"../AnimatedSprite2D"

var lock=false


func _physics_process(delta):
	if GameManager.is_game_over:
		return
	if lock:
		#get_parent().velocity=Vector2.ZERO
		#get_parent().move_and_slide()
		return
	var player_pos = GameManager.player_pos
	var difference = player_pos - get_parent().position
	input_vec = difference.normalized()
	get_parent().velocity = input_vec * speed * 100.0
	
	get_parent().move_and_slide()
	

func _process(delta):
	if GameManager.is_game_over:
		return
	rotate_sprite()

	
func rotate_sprite():
	if input_vec.x>0:
		sprite.flip_h=false
	elif input_vec.x<0:
		sprite.flip_h=true
