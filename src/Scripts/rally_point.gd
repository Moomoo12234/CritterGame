extends Node2D

@onready var rallyModule = $RallyModule

@export var placed = false
func _process(delta) -> void:
	if $RallyModule.selected and Input.is_action_pressed("Rally") and placed:
		position = get_global_mouse_position()
		for i in $RallyModule.assignedAnts:
			if i:
				i.navigation2D.target_position = position
	
	if not placed and Input.is_action_just_pressed("Rally"):
		queue_free()
	
	if not placed:
		position = get_global_mouse_position()
	
	if not placed and Input.is_action_just_pressed("Select"):
		placed = true
		$GPUParticles2D.restart()

func _on_delete_pressed() -> void:
	queue_free()
