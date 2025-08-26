extends Node2D

signal spawn
signal die

@export var ant: PackedScene

@export var maxAnts: int = -1
@export var antCost: int = 4
@export var hp: int = 10
@export var food: int = 12

@export var antsContainer: Node2D
@export var holes: Node2D
@export var rallys: Node2D

var rad = 96
var minRad = 24

#var ants 

func spawnJuice() -> void:
	$AnimationPlayer.play("Spawn")
	$Spawn.pitch_scale= randf_range(1.5, 1.6)
	$Spawn.play()
	$GPUParticles2D.restart()

func damage():
	hp -= 1
	$Hit.pitch_scale = randf_range(0.9, 1)
	$Hit.play()
	if hp <= 0:
		Globals.input_enabled = false
		emit_signal("die")
		queue_free()

func deliverFood(ant: CharacterBody2D):
	ant.deliverFood()
	food += 1

func spawnAnt(begin:bool = false) -> void:
	emit_signal("spawn")
	food -= antCost
	var antInst = ant.instantiate()
	antInst.rally = self
	antInst.position = position
	
	antInst.ants = antsContainer
	antInst.nest = self
	antInst.holes = holes
	antInst.rallys = rallys
	
	antsContainer.add_child(antInst)
	
	if not begin:
		spawnJuice()

func _ready() -> void:
	for i in range(0, floor(food / antCost)):
		spawnAnt(true)

func _process(delta) -> void:
	var tween = create_tween()
	tween.tween_property($HealthBar,"value", hp, 0.1)

func _on_timer_timeout() -> void:
	if food >= antCost and not Globals.paused:
		spawnAnt()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ant"):
		if area.get_parent().hasFood:
			deliverFood(area.get_parent())
		#else:
		#	area.get_parent().deliverFood()

func _on_sprite_2d_mouse_entered() -> void:
	if Globals.input_enabled:
		$HealthBar.visible = true

func _on_sprite_2d_mouse_exited() -> void:
	if Globals.input_enabled:
		$HealthBar.visible = false
