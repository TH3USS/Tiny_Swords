extends Node2D

@export var object_templates: Array[PackedScene]
#CAPTANDO O CLICK DO MOUSE
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				spaw_object(event.position)
				
#CRIANDO OBJETO/ o Vector2 é um tipo de variavel
func spaw_object(position: Vector2) -> void:
	var object_templates = object_templates[0]
	var object: Node2D = object_templates.instantiate()
	object.position = position
	add_child(object)
