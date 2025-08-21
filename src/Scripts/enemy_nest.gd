extends Node2D

@export var ant: PackedScene

@export var maxAnts: int
@export var waveAmount: int = 2
@export var guard_amnt: int = 5
@export var hp: int = 10

@export var antsContainer: Node2D
@export var playerNest: Node2D
@export var rallyModule: Node

var rad = 96
var minRad = 24

var ants = []
var guards = []

func damage():
	hp -= 1
	$Hit.pitch_scale = randf_range(0.9, 1)
	$Hit.play()
	if hp <= 0:
		queue_free()

func spawnAnt() -> void:
	var antInst = ant.instantiate()
	antInst.rally = self
	antInst.position = position
	
	antInst.nest = self
	#antInst.playerNest = playerNest
	
	antsContainer.add_child(antInst)
	if guards.size() >= guard_amnt:
		ants.append(antInst)
	else:
		guards.append(antInst)

func _ready() -> void:
	for i in range(0, 3):
		spawnAnt()
	
func _process(delta: float) -> void:
	if ants.size() >= waveAmount:
		for i in range(0, waveAmount):
			ants[0].assign(playerNest)
			ants[0].updateTarget()
			ants.erase(ants[0])
	var tween = create_tween()
	tween.tween_property($HealthBar,"value", hp, 0.1)

func _on_timer_timeout() -> void:
	if Globals.input_enabled and not Globals.paused:
		spawnAnt()

func _on_spawn_delay_timeout() -> void:
	$SpawnTimer.start()

func _on_sprite_2d_mouse_entered() -> void:
	$HealthBar.visible = true

func _on_sprite_2d_mouse_exited() -> void:
	$HealthBar.visible = false
