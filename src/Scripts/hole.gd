extends Node2D

@export var freeAnts: Node2D

@export var holeTextures: Array[Texture2D]
@export var holeTextureNums: Array[int]

@export var food: float = 4
@export var maxFood: float = 4

func collectFood(ant = 1) -> void:
	ant.collectFood()
	
	food -= 1
	
	for i in holeTextureNums:
		if food <= float(i):
			$Sprite2D.texture = holeTextures[i -1]
			print(i, food)
			break
	
	if food <= 0:
		queue_free()

func _ready() -> void:
	$RallyModule.ants = freeAnts

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Ant"):
		collectFood(area.get_parent())
