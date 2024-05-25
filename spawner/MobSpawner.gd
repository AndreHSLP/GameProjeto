extends Node2D
class_name MobSpanwer

@onready var path_follow_2d = $Path2D/PathFollow2D

@export var enimies:Array[PackedScene]

var mobs_p_minute:float=60.0
var cooldown:float=0.0




func _process(delta):
	if GameManager.is_game_over:
		return
	
	cooldown-=delta
	if cooldown>0:
		return
	var interval = 60/mobs_p_minute
	cooldown=interval
	
	
	var point=get_point()
	
	var world_state = get_world_2d().direct_space_state
	var parameters=PhysicsPointQueryParameters2D.new()
	parameters.position=point
	var result = world_state.intersect_point(parameters,1)
	
	if !result.is_empty():return
	
	var index=randi_range(0,enimies.size()-1)
	var creature_scene=enimies[index].instantiate()
	creature_scene.global_position=point
	get_parent().add_child(creature_scene)
	
func get_point()->Vector2:
	path_follow_2d.progress_ratio=randf()
	return path_follow_2d.global_position






