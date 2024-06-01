class_name MenuUI
extends Control

@export var controls_ui_template: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sons/MusicAudio.play()
	$VBoxContainer/Start.grab_focus()


func _on_start_pressed():
	tocar()
	get_tree().change_scene_to_file("res://main.tscn")
	

func _on_controls_pressed():
	#criar Controls
	var controls_ui: ControlsUI = controls_ui_template.instantiate()
	add_child(controls_ui)
	tocar()


func _on_quit_pressed():
	tocar()
	get_tree().quit()
	
func tocar():
	$Sons/BotaoAudio1.play()
	$Sons/BotaoAudio2.play()
