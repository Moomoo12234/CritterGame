extends Node2D

@onready var rallyModule = $RallyModule

@export var holeTextures: Array[Texture2D]
@export var holeTextureNums: Array[int]

@export var food: float = 32
@export var maxFood: float = 32

func updateTexture() -> void:
	for i in range(0, holeTextures.size()):
			if food <= float(holeTextureNums[i]):
				$Sprite2D.texture_normal = holeTextures[i]
				$Area2D/CollisionShape2D.shape.radius = (i + 1) * 6
				break

func collectFood(a = 1) -> void:
	if not a.hasFood:
		a.collectFood()
		
		
		food -= 1
		
		updateTexture()
	
		#if food <= 0:
		#	queue_free()
	else:
		a.collectFood()
		

func _process(delta: float) -> void:
	if food >= maxFood / 2 and not rallyModule.assignable:
		rallyModule.assignable = true
	var tween = create_tween()
	tween.tween_property($Label/FoodBar, "value", food, 0.1)
	tween = create_tween()
	tween.tween_property($Label/RegendBar,"value", 5.0 - $RegenTimer.time_left, 0.1)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ant") and rallyModule.assignedAnts.has(area.get_parent()):
		if food > 0:
			collectFood(area.get_parent())
		else:
			rallyModule.assignable = false
			rallyModule.clear()
			$Label.visible = false
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1)
			$AudioStreamPlayer2D.play()

func _on_regen_t_imer_timeout() -> void:
	if food < maxFood:
		food += 1
		updateTexture()
		$Label/FoodBar/AnimationPlayer.play("food")
