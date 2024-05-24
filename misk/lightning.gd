extends Node2D

@export var demage_amount: int = 1

@onready var area2D: Area2D = $Area2D

func deal_demage():
	var bodies = area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.demage(demage_amount)
			$Sounds/HitSound.play()
			if enemy.health <= 0:
				if enemy.is_in_group("goblin"):
					$Sounds/GDeath.play()
				elif enemy.is_in_group("pawnR"):
					$Sounds/PRDeath.play()
				elif enemy.is_in_group("pawnV"):
					$Sounds/PVDeath.play()
				elif enemy.is_in_group("sheep"):
					$Sounds/SDeath.play()

@onready var path_follow_2D: PathFollow2D = $PathFollow2D

func get_point() -> Vector2:
	path_follow_2D.progress_ratio = randf()
	return path_follow_2D.global_position
