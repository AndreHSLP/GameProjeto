extends Path2D


var path_follow_2d:PathFollow2D

func _ready():
	path_follow_2d = $PathFollow2D
	curve=curve.duplicate()
	curve.set_point_position(1,to_local(GameManager.player_pos))
