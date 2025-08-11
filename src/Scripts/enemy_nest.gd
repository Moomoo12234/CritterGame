extends Node2D

@export var ant: PackedScene

@export var maxAnts: int
@export var waveAmount: int
@export var hp: int

@export var antsContainer: Node2D
@export var playerNest: Node2D
@export var rallyModule: Node

var rad = 128
var minRad = 24

var ants = []

func damage():
	hp -= 1
	if hp <= 0:
		queue_free()

func spawnAnt() -> void:
	var antInst = ant.instantiate()
	antInst.rally = self
	antInst.position = position
	
	antInst.nest = self
	#antInst.playerNest = playerNest
	
	antsContainer.add_child(antInst)
	
	ants.append(antInst)
	
func _process(delta: float) -> void:
	if ants.size() >= waveAmount:
		for i in range(0, waveAmount):
			ants[0].assign(playerNest)
			ants[0].updateTarget()
			ants.erase(ants[0])

func _on_timer_timeout() -> void:
	spawnAnt()

func _on_spawn_delay_timeout() -> void:
	$SpawnTimer.start()
