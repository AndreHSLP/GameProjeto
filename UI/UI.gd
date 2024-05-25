extends CanvasLayer


@onready var timer_label:Label = $TimerLabel

@onready var meat_label:Label = $Panel/MeatLabel
@onready var gold_label:Label = $Panel/GoldLabel



func _process(delta):
	timer_label.text=GameManager.time_elapsed_str
	meat_label.text=str(GameManager.meat_counter)
