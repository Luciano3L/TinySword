extends Node2D

@export var regeneration_amount: int = 25

@onready var area2d: Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(on_corpo_entrou)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_corpo_entrou(body):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		player.meat_collected.emit(regeneration_amount)
		queue_free()
