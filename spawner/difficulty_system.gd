extends Node


@export var mob_spawner:MobSpanwer
@export var initial_spawn_rate: float = 60.0
@export var spawn_rate_per_min:int = 30
@export var wave_duration:float = 20.0
@export var break_intesity: float = 0.5

var time:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.is_game_over:
		return
	time += delta
	
	#dificuldade linear
	var spawn_rate = initial_spawn_rate + (spawn_rate_per_min * (time/60))
	
	#onda
	var sin_wave = sin((time*TAU)/wave_duration)
	var wave_factor = remap(sin_wave,-1.0,1.0,break_intesity, 1)
	spawn_rate*=wave_factor
	
	#aplicar dificuldade
	mob_spawner.mobs_p_minute = initial_spawn_rate
	
	
