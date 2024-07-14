extends Node

@export var ene_spawner: EneSpawner
@export var ini_spawn_rate: float = 60.0
@export var spawn_rate_per_minute: float = 30.0
@export var wave_duration: float = 20.0 
@export var break_intensity: float = 0.5

var time: float = 0.0


func _process(delta):
	# ignorar game over
	if GameManager.is_game_over: return
	
	
	if Input.is_action_pressed("hard"):
		ini_spawn_rate = 1000.0
		
	if Input.is_action_pressed("reset"):
		GameManager.reset()
		get_tree().reload_current_scene()
	
	# incrementar temporizador
	time += delta
	
	# dificuldade linear
	var spawn_rate: float = ini_spawn_rate + spawn_rate_per_minute * (time / 60.0)
	
	# sistema de ondas (variação osinoide)
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave,-1.0,1.0,break_intensity,1)
	spawn_rate *= wave_factor
	
	# aplica dificuldade
	ene_spawner.ene_per_minute = spawn_rate	
	
