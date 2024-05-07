class_name  Player
extends CharacterBody2D

@export_category("Moviment")
@export var speed: float = 3.0
@export_category("Sword")
@export var sword_demage: int = 1
@export_category("Ritual")
@export var ritual_demage: int = 1
@export var ritual_interval: float = 30
@export var ritual_scene: PackedScene
@export_category("Life")
@export var health: int = 1000
@export var max_health: int = 1000
@export var death_prefab: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitBoxArea
@onready var health_progress_bar: ProgressBar = $HealthProgressBar

var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0.0

signal meat_collected(valor: int)

func _ready():
	GameMenager.player = self
	meat_collected.connect(func(valor: int): GameMenager.meat_counter += 1)

func _process(delta: float) -> void:
	GameMenager.player_position = position
	
	
	
	#ler input
	read_input()
	
	update_attack_cooldown(delta)
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	#processar animação e requisição de sprite
	play_run_idle_animation()
	
	#Processando animacao e rotacao do sprite
	if not is_attacking:
		rotate_sprite()
	
	#processando dano
	update_hitbox_direction(delta)
	
	#ritual
	update_ritual(delta)
	
	#atualizando health bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health



func _physics_process(delta: float) -> void:
	#modificar velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()

func update_attack_cooldown(delta: float) -> void:
	#atualiza temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_ritual(delta: float) -> void:
	 #atualiza temporizador
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	#criar ritual
	var ritual = ritual_scene.instantiate()
	ritual.demage_amount = ritual_demage
	add_child(ritual)

func read_input() -> void:
	#verificando se o botão foi precionado
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	#atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
	#troca animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	#gira sprite
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if is_attacking:
		return
	var attack_type =  randi_range(1, 2)
	#tocar animação
	if Input.is_action_pressed("move_up"):
		if attack_type == 1: animation_player.play("attack_up_1")
		elif attack_type == 2: animation_player.play("attack_up_2")
	elif Input.is_action_pressed("move_down"):
		if attack_type == 1: animation_player.play("attack_down_1")
		elif attack_type == 2: animation_player.play("attack_down_2")
	else:
		if attack_type == 1: animation_player.play("attack_side_1")
		elif attack_type == 2: animation_player.play("attack_side_2")
	attack_cooldown = 0.6
	
	# marcar ataque
	is_attacking = true
	

func deal_demage_with_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.demage(sword_demage)


func update_hitbox_direction(delta: float) -> void:
	#temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	#frequencia
	hitbox_cooldown = 0.5
	
	#detectar inimigo
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			if body.is_in_group("goblin"):
				print("goblin")
				var demage_amount = 10
				demage(demage_amount)
			elif body.is_in_group("pawn"):
				print("pawn")
				var demage_amount = 5
				demage(demage_amount)
			elif body.is_in_group("sheep"):
				print("sheep")
				var demage_amount = 2
				demage(demage_amount)
			
func demage(amount: int) -> void:
	health -= amount
	print("payer-demage:", amount, " player-health:", health)
	
	#pisca vermelho no dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		die()
		
func die() -> void:
	GameMenager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	print("player morreu")
	queue_free()

func heal(amount:int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Recebeu cura de: ", amount, " vida total: ", health, "/", max_health)
	return health
