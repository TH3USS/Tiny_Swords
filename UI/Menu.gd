extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Start.grab_focus()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_controls_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
