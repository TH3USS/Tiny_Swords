extends CanvasLayer


@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel

func _process(delta: float):
	#update labels
	timer_label.text = GameMenager.time_elapsed_string
	meat_label.text = str(GameMenager.meat_counter)

