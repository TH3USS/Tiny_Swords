class_name Goblin
extends Enemy

@onready var animation_goblin: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_of_hit: Area2D = $AreaOfHit
@onready var die_sound: AudioStreamPlayer = $Sounds/Die
@onready var hit_cooldown: float = 0.0

var attacking: bool = false

func _process(delta):
	hit_play(delta)
	
func hit_play(delta):
	hit_cooldown -= delta
	if hit_cooldown > 0: 
		attacking = false
		return
	
	#frequencia
	hit_cooldown = 0.5
	
	#verificando se está perto para atacar
	var bodies = area_of_hit.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("player"):
			attacking = true
			if attacking:
				animation_goblin.play("attack")
		else:
			if attacking == false:
				animation_goblin.play("default")


