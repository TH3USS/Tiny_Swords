class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 10
@export var death_prefab: PackedScene

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_itens: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var damage_digit_marker = $DamageDigitMarker
@onready var damage_digit_prefab = preload("res://misk/damage_digit.tscn")#transformar em um PackedScene


func demage(amount: int) -> void:
	health -= amount
	print("enemy-demage:", amount, " enemy-health:", health)
	print(amount)
	GameMenager.demage_did = amount
	
	#pisca vermelho no dano
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	#criar DamageDigit
	var damage_digit = damage_digit_prefab.instantiate()
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		die()
		
func die() -> void:
	#caveira
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
		#drop
		if randf() <= drop_chance:
			drop_item()
		
		#incremetar contador
	GameMenager.monsters_defeated_counter += 1
	GameMenager.ofensive_running = true
	GameMenager.ofensive_kills += 1
	GameMenager.ofensive_cooldown = 100
		
	queue_free()

func drop_item() -> void:
	var drop = get_randon_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	

func get_randon_drop_item() -> PackedScene:
	#lista com 1 item
	if drop_itens.size() == 1:
		return drop_itens[0]
	
	#calcular chance maxima
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	#jogar dado
	var random_value = randf() * max_chance
	
	#girar a roleta
	var needle: float = 0.0
	for i in drop_itens.size():
		var drop_item = drop_itens[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_itens[0]

#poder de empurrão
func push(vec: Vector2):
	var test = position - vec
	position = test


