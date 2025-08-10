extends Node2D

@export var freeAnts: Node2D

func _ready() -> void:
	$RallyModule.ants = freeAnts
