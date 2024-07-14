class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D =$SwordArea
@onready var hitbox_area: Area2D =$HitBoxArea
@onready var life_progress_bar: ProgressBar = $lifeProgressBar

@export var speed: float = 3
@export var damage_sword: int = 30

@export var health = 100
@export var max_health = 100
@export var death_prefab: PackedScene


var input_vector: Vector2 =Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown : float = 0.0
var hitbox_cooldown: float = 0.0

signal meat_collected(value:int)

var input_attack
var dire_attack


func _ready():
	GameManager.player = self

func _process(delta: float):
	
	#inject position of play no manager game
	GameManager.player_position = position
	
	# obter os imputs de movimento 
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	# atualizar e saber se esta movimentando
	was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	
	input_attack = Input.is_action_pressed("attack")
	
	
	
	
	# trocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idie")

	# girar sprite
	if not is_attacking:
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true

	# attack
	cooldown(delta)
	if input_attack and input_vector.y < 0:
		dire_attack = Vector2.UP 
		attack("attack_up_1")
	elif input_attack and input_vector.y > 0:
		dire_attack = Vector2.DOWN
		attack("attack_down_1")
	elif input_attack:
		dire_attack = false
		attack("attack_side_1")
		
	# processar dano player
	update_hitbox_detection(delta)



func _physics_process(delta):
	
	# modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking: 
		target_velocity *= 0.1
	velocity = lerp(velocity,target_velocity,0.2)
	move_and_slide()

func cooldown(delta):
	# atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idie")

func attack(tipo):
	
	# Animação do attack
	if is_attacking:
		return
	animation_player.play(tipo)
	attack_cooldown = 0.35
	is_attacking = true



func deal_damage_aula():
		# Aplicar damage do attack
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemys"):
			var enemy: Enemy = body
			var direction_enemy = (enemy.position - position).normalized()
			var attack_direction:Vector2
			
			
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else: 
				attack_direction = Vector2.RIGHT
			
			
			var dot_product = direction_enemy.dot(attack_direction)
			if dot_product >=0.3:
				enemy.damage(damage_sword)
				print(input_vector)
	
func deal_damage():
		# Aplicar damage do attack
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemys"):
			var enemy: Enemy = body
			var direction_enemy = (enemy.position - position).normalized()
			var attack_direction:Vector2
			
			if !dire_attack:
				if sprite.flip_h:
					attack_direction = Vector2.LEFT
				else: 
					attack_direction = Vector2.RIGHT
			else:
				attack_direction = dire_attack
				
			var dot_product = direction_enemy.dot(attack_direction)
			if dot_product >=0.3:
				enemy.damage(damage_sword)
	
	#var groupEnemy = get_tree().get_nodes_in_group("enemys")
	#for enemy in groupEnemy:
	#	enemy.damage(damage_sword)

func update_hitbox_detection(delta: float):
	
	# temporizador dano
	hitbox_cooldown-=delta
	if hitbox_cooldown > 0: return
	
	# frequencia de dano
	hitbox_cooldown =0.5
	
	# find enemy and make a hit
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemys"):
			var enemy: Enemy = body
			damage(2)


func damage(amount:int):	
# Processar a morte
	if health <= 0: return
	health -= amount
	life_progress_bar.value = health
	if health <= 0:
		die()
	
# Processar dano no sprite
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.15)

func die():
	GameManager.end_game()
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		get_parent().add_child(death_obj)
	queue_free()

func heal(amount)->int:
	health+=amount
	if health > max_health:
		health = max_health
	life_progress_bar.value = health
	return health


