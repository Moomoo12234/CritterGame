extends Node2D

@onready var rallyModule = $RallyModule

@export var holeTextures: Array[Texture2D]
@export var holeTextureNums: Array[int]

@export var food: float = 4
@export var maxFood: float = 4

func collectFood(a = 1) -> void:
	if not a.hasFood:
		a.collectFood()
		
		food -= 1
		
		for i in range(0, holeTextures.size()):
			if food <= float(holeTextureNums[i]):
				$Sprite2D.texture_normal = holeTextures[i]
				break
	
		if food <= 0:
			queue_free()

func _process(delta: float) -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ant") and rallyModule.assignedAnts.has(area.get_parent()):
		collectFood(area.get_parent())
