extends CanvasLayer

@onready var btn_raio: Panel = $Panel2
@onready var btn_raio_defaut: Panel = $Panel4
@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var kill_label: Label = %KillsLabel
@onready var ofensive_label: Label = %OfensiveLabel
@onready var progressso: ProgressBar = $Progresso
@onready var progressso2: ProgressBar = $Progresso2

#contador raio
var lightning_interval: float = 10
var lightning_cooldown: float = 10
var aux: float = 10

#contador empurão
var pushing_interval: float = 10
var pushing_cooldown: float = 10
var aux2: float = 10

func _process(delta: float) -> void:
	#update labels
	timer_label.text = GameMenager.time_elapsed_string
	meat_label.text = str(GameMenager.meat_counter)
	kill_label.text = str(GameMenager.monsters_defeated_counter)
	
	texto()
	
	
	update_lightning(delta)
	
	update_pushing(delta)

func update_lightning(delta: float) -> void:
	if GameMenager.was_lightning == false:
		if GameMenager.l_on == true:
			$Sounds/LightningClick.play()
			btn_raio.visible = true
			btn_raio_defaut.visible = false
		elif GameMenager.l_on == false:
			$Sounds/LightningClick.play()
			btn_raio.visible = false
			btn_raio_defaut.visible = true
	elif GameMenager.was_lightning:
		if progressso.value == 10:
			aux = 0
			progressso.value = 0
		#atualiza temporizador
		lightning_cooldown -= delta
		btn_raio.visible = false
		btn_raio_defaut.visible = true
		GameMenager.l_on = false
		
		aux += delta
		progressso.value = aux
		
		if lightning_cooldown > 0: return
		lightning_cooldown = lightning_interval
		progressso.value = 10
		#ativa o botão de novo
		GameMenager.was_lightning = false

func update_pushing(delta: float) -> void:
	if GameMenager.p_on:
		if progressso2.value == 10:
			$Sounds/PushClick.play()
			aux2 = 0
			progressso2.value = 0
		#atualiza temporizador
		pushing_cooldown -= delta
		
		aux2 += delta
		progressso2.value = aux2
		
		if pushing_cooldown > 0: return
		pushing_cooldown = pushing_interval
		progressso2.value = 10
		
		GameMenager.p_on = false

func texto():
	#texto combo
	if GameMenager.ofensive_running:
		ofensive_label.visible = true
		if GameMenager.ofensive_kills < 4:
			ofensive_label.modulate = Color.WHITE
			ofensive_label.scale = Vector2(0.8,0.8)
		elif GameMenager.ofensive_kills >= 4 && GameMenager.ofensive_kills < 7:
			ofensive_label.modulate = Color.DARK_ORANGE
			ofensive_label.scale = Vector2(0.9,0.9)
		elif GameMenager.ofensive_kills > 7:
			ofensive_label.modulate = Color.RED
			ofensive_label.scale = Vector2(1,1)
			if GameMenager.ofensive_kills > 10:
				GameMenager.special_on = true
		ofensive_label.text = str("x", GameMenager.ofensive_kills)
	else:
		ofensive_label.visible = false
		pass
