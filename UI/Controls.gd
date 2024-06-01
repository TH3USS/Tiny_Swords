class_name ControlsUI
extends Control


func _on_start_pressed():
	$Sons/BotaoAudio1.play()
	$Sons/BotaoAudio2.play()
	self.queue_free()
