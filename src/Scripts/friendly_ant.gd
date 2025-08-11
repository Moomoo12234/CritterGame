extends ant

@export var empty: Texture2D
@export var full: Texture2D


var ants: Node2D
var holes: Node2D
var rallys: Node2D

var hasFood: bool = false

func hurt(ant: CharacterBody2D):
	ant.damage()

func damage():
	hp -= 1
	accelVector = -2
	$Hit.pitch_scale = randf_range(0.9, 1.1)
	$Hit.play()

func lookForJob() -> void:
	if not assigned:
		for i in rallys.get_children():
			if i.rallyModule.antsNeeded > 0:
				i.rallyModule.addAnt(self)
				assign(i.rallyModule)
				break
			
		for i in holes.get_children():
			if i.rallyModule.antsNeeded > 0:
				i.rallyModule.addAnt(self)
				assign(i.rallyModule)
				break

func deliverFood() -> void:
	$Sprite2D.texture = empty
	if rally:
		pickTarget(rally)
	else:
		unassign()
	hasFood = false

func collectFood():
	$Sprite2D.texture = full
	target = nest.position
	hasFood = true

func process() -> void:
	if not assigned:
			lookForJob()
	if not rally:
		unassign()

func _on_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy ant") or area.is_in_group("Enemy nest"):
		eTargets.append(area.get_parent())

func _on_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemy ant"):
		eTargets.erase(area.get_parent())

func _on_area_2d_area_entered(area: Area2D) -> void:
	if hp > 0:
		if area.is_in_group("Enemy ant"):
			hurt(area.get_parent())
			damage()
		if area.is_in_group("Enemy nest"):
			area.get_parent().damage()
			knockback()
