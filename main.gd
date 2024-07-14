extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_templante: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_over.connect(trigger_game_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("esc"):
		get_tree().quit()
		

func trigger_game_over():
	# deletar gameUI(main)
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	# criar gameover_UI
	add_child(game_over_ui_templante.instantiate())
