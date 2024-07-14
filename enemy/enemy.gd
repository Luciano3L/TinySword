class_name Enemy
extends Node2D

@export var health = 10
@export var death_prefab: PackedScene

var damage_digit_prefab: PackedScene
@onready var damage_digit_marker = $DamageDigitMarker

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_iten_chance: Array[float]


func _ready():
	damage_digit_prefab = preload("res://misc/damage_digit.tscn")

func damage(amount:int):
	health -= amount
	if health <= 0:
		die()
	
# Processar dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.15)


	# Criar Digit damagem
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	damage_digit.position = damage_digit_marker.global_position
	get_parent().add_child(damage_digit)

func die():
	
	# caveira
	if death_prefab:
		var death_obj = death_prefab.instantiate()
		death_obj.position = position
		death_obj.position.y -=45
		get_parent().add_child(death_obj)
	
	# drop item
	if randf() <= drop_chance:
		drop_item()
	
	# icrementa o contador
	GameManager.ene_defeated_counter += 1
	
	# delete node
	queue_free()

func drop_item():
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)

# drop sistema itens raros e normal
func get_random_drop_item() -> PackedScene:
	if drop_items.size() == 1: 
		return drop_items[0]
	
	var max_chances: float = 0.0
	for drop_chance in drop_iten_chance:
		max_chances += drop_chance
	
	var rando_value = randf() + max_chances
	
	# girar roleta
	var needle: float = 0.0
	for i in drop_items.size():
		#var drop_item = drop_items[i]
		var drop_chance = drop_iten_chance[i] if i < drop_iten_chance.size() else 1
		if rando_value <= drop_chance+needle:
			return drop_items[i]
		needle += drop_chance
	return drop_items[0]
	
