extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@export var lightning_scene: PackedScene
@export var pushing_scene: PackedScene




func _ready():
	GameMenager.game_over.connect(trigger_game_over)
	$Sounds/musica.play()

func trigger_game_over():
	$Sounds/musica.stop()
	#deletar gameui
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	#criar GameOverUI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)



	#CAPTANDO O CLICK DO MOUSE
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				if GameMenager.l_on == true:
					lightning(event.position)
	
	if Input.is_action_pressed("turn_lightning"):		
		if GameMenager.l_on == false: GameMenager.l_on = true
		elif GameMenager.l_on == true: GameMenager.l_on = false
		if GameMenager.was_lightning:
			return
		$Sounds/LightningClick.play()
	
	if Input.is_action_pressed("play_push"):
		if GameMenager.p_on == false:
			$Sounds/PushClick.play()
			pushing()
			GameMenager.p_on = true

func lightning(p: Vector2) -> void:
	#CRIANDO OBJETO raio
	var object_template = lightning_scene
	var object: Node2D = object_template.instantiate()
	
	#calculando a posição assim que sai da tela original
	var posicao_padrao = Vector2(581, 354) - p
	object.position = (posicao_padrao - GameMenager.player_position) * (-1)
	
	GameMenager.was_lightning = true
	
	$Sounds/lightning1.play()
	$Sounds/lightning2.play()
		
	add_child(object)

func pushing():
	var object_template2 = pushing_scene
	var object2: Node2D = object_template2.instantiate()
	object2.position = GameMenager.player_position
	$Sounds/Push.play()
	add_child(object2)
