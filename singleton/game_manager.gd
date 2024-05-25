extends Node


var player:Player
var player_pos:Vector2
var is_game_over:bool=false

var meat_counter:int=0
var time_elapsed: float=0.0
var time_elapsed_str:String
var monster_defeat_counter:int=0

signal on_game_over

func end_game():
	if is_game_over:return
	is_game_over=true
	on_game_over.emit()


func reset():
	player=null
	player_pos=Vector2.ZERO
	is_game_over=false
	
	meat_counter=0
	time_elapsed=0.0
	time_elapsed_str="00:00"
	monster_defeat_counter=0
	#desconectar tudo
	for c in on_game_over.get_connections():
		on_game_over.disconnect(c.callable)


func _process(delta):
	time_elapsed+=delta
	
	var time_elapsed_in_mseconds:int=floori(time_elapsed)
	var seconds:int=time_elapsed_in_mseconds % 60
	var minutes:int=time_elapsed_in_mseconds / 60
	time_elapsed_str = "%02d:%02d"%[minutes,seconds]


