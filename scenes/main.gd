extends Node

@onready var game_ui:CanvasLayer = $UI
#@onready var game_over_ui:CanvasLayer = $GameOverUI


@export var GAME_OVER_UI_prefab:PackedScene
#@export var UI_prefab:PackedScene

func _ready():
	GameManager.on_game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui=null
	
	var game_over_ui = GAME_OVER_UI_prefab.instantiate()
	add_child(game_over_ui)



