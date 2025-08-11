extends Node2D

@onready var rallyModule = $RallyModule

func _process(delta) -> void:
	if $RallyModule.selected and Input.is_action_pressed("Rally"):
		position = get_global_mouse_position()
		for i in $RallyModule.assignedAnts:
			i.updateTarget()
