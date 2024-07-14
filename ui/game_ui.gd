extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel

var meat_counter:int = 0

func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	meat_label.text = str(meat_counter)
func _process(delta):
	
	# UI timer do jogo
	timer_label.text = GameManager.time_elapsed_str

func on_meat_collected(regeneration_value: int):
	meat_counter += 1
	meat_label.text = str(meat_counter)
