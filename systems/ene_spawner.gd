class_name EneSpawner
extends Node2D

@export var creatures: Array[PackedScene]
var ene_per_minute: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

var cooldown: float = 0.0

func _process(delta):
	# ignorar game over
	if GameManager.is_game_over: return
	
	# temporizador
	cooldown -= delta
	if cooldown > 0: return
	
	# frequencia monstro
	var intervalo = 60.0 / ene_per_minute
	cooldown = intervalo
	
	# checar o limit do mundo / se ponto é valido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty():return
	
	# instacia creatura aleatoria
	var index_rando = randi_range(0, creatures.size()-1)
	var creatura_scene = creatures[index_rando]
	var creature = creatura_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

