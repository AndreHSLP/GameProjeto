extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var speed: float = 3.0
@export_category("Sword")
@export var sword_damage:int = 2
@export_category("Life")
@export var health:int=100
@export var max_health:int=100
@export_category("Death")
@export var death_prefab:PackedScene
@export_category("Ritual")
@export var ritual_scene:PackedScene
@export var ritual_damage:int=1
@export var ritual_interval:float=30


@onready var health_progress_bar:ProgressBar = $HealthProgressBar

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite:Sprite2D = $Sprite

@onready var sword_area:Area2D = $SwordArea
@onready var hit_box_area = $HitBoxArea

var input_vec:Vector2=Vector2.ZERO
var is_running=false
var was_running=false
var is_attacking=false
var atk_cooldown:float= 0.0
var hitbox_cooldown:float= 0.0
var ritual_cooldown:float=0.0


signal meat_collected(value:int)

func _ready():
	GameManager.player=self
	meat_collected.connect(func(value:int):
		GameManager.meat_counter+=1
	)

func _process(delta:float)->void:
	GameManager.player_pos=position
	#entrada player
	read_input()
	
	update_atk_cooldown(delta)
	
	#temporirador do atk
	play_run_idle_animation()

	# atualizar direção
	if !is_attacking:
		rotate_sprite()
	
	#atacar
	if Input.is_action_just_pressed("atk"):
		attack()
	
	update_hitbox_detection(delta)
	
	update_ritual(delta)
	
	update_healthbar()
	
func _physics_process(delta:float)->void:
	#vetor do input
	

	#modificar velocidade
	var target_velocity = input_vec*speed*100
	
	if is_attacking:
		target_velocity=target_velocity*0.25
	
	velocity=lerp(velocity,target_velocity,0.05)
	move_and_slide()

func attack():
	if is_attacking:
		return
	
	#tocar animação
	animation_player.play("atk_side_1")
	
	#configura temporizador
	atk_cooldown=0.6
	
	#marca atk
	is_attacking=true
	
func read_input():
	# vetor direção

	input_vec = Input.get_vector("move_left","move_right","move_up","move_down")
	
	var deadzone=0.15
	if abs(input_vec.x)<deadzone:
		input_vec.x=0.0
	if abs(input_vec.y)<deadzone:
		input_vec.y=0.0
		
	was_running = is_running
	is_running = not input_vec.is_zero_approx()

func play_run_idle_animation():
	
	if !is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite():
	if input_vec.x>0:
		sprite.flip_h=false
	elif input_vec.x<0:
		sprite.flip_h=true

func  update_atk_cooldown(delta):
	if is_attacking:
		atk_cooldown-=delta
		if atk_cooldown<=0.0:
			is_attacking=false
			is_running=false
			animation_player.play("idle")

func deal_damage_to_enemies()->void:
	
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy=body
			var direc_To_Enemy = (enemy.global_position-position).normalized()
			var atk_Direction
			if sprite.flip_h:
				atk_Direction=Vector2.LEFT
			else:
				atk_Direction=Vector2.RIGHT
				
			var dot = direc_To_Enemy.dot(atk_Direction) 
			
			if dot>=0.3:
				enemy.damage(sword_damage)

func damage(amount:	int) -> void:
	if health<=0:
		return
	health-= amount
	
	#piscar
	modulate=Color.RED
	
	var tw=create_tween()
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_QUINT)
	tw.tween_property(self,"modulate",Color.WHITE,0.3)

	if health<=0:
		die()

func die()->void:
	GameManager.end_game()
	if death_prefab:
		var death_object=death_prefab.instantiate()
		death_object.position=position
		get_parent().add_child(death_object)
	queue_free()

func update_hitbox_detection(delta)->void:
	
	hitbox_cooldown-=delta
	
	if hitbox_cooldown>0:
		return
	
	hitbox_cooldown=0.5
	var bodies = hit_box_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy=body
			var damage_amount = 1
			damage(damage_amount)

func heal(amount:int)->int:
	health+=amount
	if health>max_health:
		health=max_health
		pass
	
	return health

func update_ritual(delta:float):
	#temporizador
	ritual_cooldown-=delta
	if ritual_cooldown>0: return
	
	ritual_cooldown = ritual_interval
	var ritual=ritual_scene.instantiate()
	ritual.damage_amount=ritual_damage
	add_child(ritual)
	
	pass


func update_healthbar():
	health_progress_bar.max_value=max_health
	health_progress_bar.value=health
	
