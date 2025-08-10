extends Node2D

@export var ant: PackedScene

@export var maxAnts: int

@export var freeAnts: Node2D
@export var ants: Node2D

var rad = 128
var minRad = 24

var food: int = 1

func deliverFood(ant: CharacterBody2D):
	ant.deliverFood()
	food += 1

func spawnAnt() -> void:
	if ants.get_child_count() + freeAnts.get_child_count() < maxAnts:
		var antInst = ant.instantiate()
		antInst.rally = self
		antInst.position = position
		
		antInst.freeAnts = freeAnts
		antInst.ants = ants
		antInst.nest = self
		
		freeAnts.add_child(antInst)

func _on_timer_timeout() -> void:
	spawnAnt()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Ant"):
		if area.get_parent().hasFood:
			deliverFood(area.get_parent())
