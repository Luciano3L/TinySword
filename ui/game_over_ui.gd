extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var ene_label: Label = %EneLabel

@export var restart_delay: float = 6.5
var restart_cooldown: float


# Called when the node enters the scene tree for the first time.
func _ready():
	time_label.text = GameManager.time_elapsed_str
	ene_label.text = str(GameManager.ene_defeated_counter)
	restart_cooldown = restart_delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		GameManager.reset()
		get_tree().reload_current_scene()
