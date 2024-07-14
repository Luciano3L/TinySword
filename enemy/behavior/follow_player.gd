extends Node


@export var SPEED: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D 

# pegando dados do persona para executar açoes
func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
# ignorar game over
	if GameManager.is_game_over: return

	# IA de follown player
	
	# calculo direção 
	var player_position = GameManager.player_position
	var diferenca = player_position - enemy.position 
	var input_vector = diferenca.normalized()
	
	# faz caminhada
	enemy.velocity = input_vector * SPEED * 100.0
	enemy.move_and_slide()
	
	# girar sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
