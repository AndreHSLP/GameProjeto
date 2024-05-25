extends Node2D


@onready var label = $Node2D/Label
var value:int = 1


func _ready():
	label.text=str(value)
