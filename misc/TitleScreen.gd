extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.intro_done()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset") and GameManager.is_game_intro_done:
		get_tree().change_scene_to_file("res://main.tscn")

	if Input.is_action_pressed("esc"):
		get_tree().quit()
