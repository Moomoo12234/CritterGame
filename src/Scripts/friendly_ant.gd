extends ant

@export var empty: Texture2D
@export var full: Texture2D


var ants: Node2D
var holes: Node2D
var rallys: Node2D

var hasFood: bool = false

func foodJuice() -> void:
	$Food.pitch_scale = randf_range(0.9, 1)
	$Food.play()
	$GPUParticles2D.restart()
	$AnimationPlayer.play("food")

func hurt(ant: CharacterBody2D):
	ant.damage()

func damage():
	hp -= 1
	knockback()
	$Hit.pitch_scale = randf_range(0.9, 1.1)
	$Hit.play()

func lookForJob() -> void:
	for i in rallys.get_children():
		if i.rallyModule.assignedAntsNum > i.rallyModule.assignedAnts.size() and i.rallyModule.assignable:
			i.rallyModule.addAnt(self)
			assign(i.rallyModule)
			break
	
	var closest: Node = null
	if not assigned:
		for i in holes.get_children():
			if i.rallyModule.assignedAntsNum > i.rallyModule.assignedAnts.size() and i.rallyModule.assignable:
				if not closest:
					closest = i
				if nest.position.distance_to(i.position) <= nest.position.distance_to(closest.position):
					closest.rallyModule.assignedAnts.erase(self)
					closest = i
					i.rallyModule.addAnt(self)
					assign(i.rallyModule)

func deliverFood() -> void:
	$Sprite2D.texture = empty
	if rally:
		pickTarget(rally)
	else:
		unassign()
	hasFood = false
	foodJuice()

func collectFood():
	$Sprite2D.texture = full
	navigation2D.target_position = nest.position
	hasFood = true
	foodJuice()

#func move(dt) -> void:
#	pass

func process() -> void:
	if not assigned and not hasFood and nest:
			lookForJob()
	elif hasFood and nest:
		navigation2D.target_position = nest.position
		reachedTarget = false
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
		if area.is_in_group("Enemy ant") and area.get_parent().hp > 0:
			area.get_parent().damage()
			damage()
		if area.is_in_group("Enemy nest"):
			area.get_parent().damage()
			knockback()
