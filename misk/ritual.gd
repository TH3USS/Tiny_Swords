extends Node2D

@export var demage_amount: int = 1

@onready var area2D: Area2D = $Area2D

func deal_demage():
	var bodies = area2D.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.demage(demage_amount)
