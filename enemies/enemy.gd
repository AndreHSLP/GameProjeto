extends Node2D
class_name Enemy

@export_category("Life")
@export var health:int=10
@export var death_prefab:PackedScene


@export_category("Drops")
@export var drop_prefabs:Array[PackedScene]
@export var drop_chances:Array[float]


var DAMAGE_DIGITS_prefab:PackedScene
@onready var damege_digit_marker_2d = $DamegeDigitMarker2D



func _ready():
	DAMAGE_DIGITS_prefab = preload("res://sfx/damage_digits.tscn")
	
	
	
func damage(amount:	int) -> void:
	health-= amount
	
	#piscar
	modulate=Color.RED
	
	var tw=create_tween()
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_QUINT)
	tw.tween_property(self,"modulate",Color.WHITE,0.3)
	
	var damage_digit = DAMAGE_DIGITS_prefab.instantiate()
	damage_digit.value=amount
	if damege_digit_marker_2d:
		damage_digit.global_position=damege_digit_marker_2d.global_position
	else:
		damage_digit.global_position=global_position
	
	get_parent().add_child(damage_digit)
	
	if health<=0:
		die()

func die()->void:
	if death_prefab:
		var death_object=death_prefab.instantiate()
		death_object.position=position
		get_parent().add_child(death_object)
	

	drop_item()
	
	queue_free()
	GameManager.monster_defeat_counter+=1

func drop_item()->void:
	var item=get_random_drop_item().instantiate()
	item.position=position
	get_parent().add_child(item)
	
func get_random_drop_item():
	if drop_prefabs.size()==1:
		return drop_prefabs[0]
	
	var max_chance:float=0.0
	
	for drop_chance in drop_chances:
		max_chance+=drop_chance
		
	# jogar dado
	var randon_value = randf_range(0.0,max_chance)
	
	#roleta
	var needle:float=0.0
	for i in drop_prefabs.size():
		var drop_item=drop_prefabs[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if randon_value <= drop_chance+needle:
			return drop_item
		needle+=drop_chance
	
	return drop_prefabs[0]
