extends Node2D

@export var ant: PackedScene

@export var maxAnts: int
@export var antCost: int
@export var hp: int

@export var ants: Node2D
@export var holes: Node2D
@export var rallys: Node2D

var rad = 128
var minRad = 24

@export var food: int = 2

func damage():
	hp -= 1
	if hp <= 0:
		queue_free()

func deliverFood(ant: CharacterBody2D):
	ant.deliverFood()
	food += 1

func spawnAnt() -> void:
	if ants.get_child_count() < maxAnts:
		food -= antCost
		var antInst = ant.instantiate()
		antInst.rally = self
		antInst.position = position
		
		antInst.ants = ants
		antInst.nest = self
		antInst.holes = holes
		antInst.rallys = rallys
		
		ants.add_child(antInst)

func _ready() -> void:
	spawnAnt()

#func _process(delta: float) -> void:
	#$Label.text = str(freeAnts.get_child_count())

func _on_timer_timeout() -> void:
	if food >= antCost:
		spawnAnt()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ant"):
		if area.get_parent().hasFood:
			deliverFood(area.get_parent())
