extends Node2D

@onready var rallyModule = $RallyModule

@export var placed = false
var deselected: bool = false

func _ready() -> void:
	if not Globals.rallyPlaced:
		Globals.rallyPlaced = true
		$Tutorial/Label.visible = true
		Globals.scaleUp($Tutorial/Label)

func _process(delta) -> void:
	if $RallyModule.selected and Input.is_action_pressed("Rally") and placed:
		position = get_global_mouse_position()
		for i in $RallyModule.assignedAnts:
			if i:
				i.navigation2D.target_position = position
		
		if not Globals.rallyMoved and Globals.rallySelected:
			Globals.rallyMoved = true
			await Globals.shrinkDown($Tutorial/Label3).finished
			$Tutorial/Label3.visible = false
	
	if not placed and Input.is_action_just_pressed("Rally"):
		queue_free()
	
	if not placed:
		position = get_global_mouse_position()
	
	if not placed and Input.is_action_just_pressed("Select"):
		placed = true
		$Sprite2D/Juice.enabled = true
		await Globals.shrinkDown($Tutorial/Label).finished
		$Tutorial/Label.visible = false

func _on_delete_pressed() -> void:
	queue_free()

func _on_rally_module_deselected() -> void:
	if not Globals.rallySelected and not deselected:
		deselected = true
		$Tutorial/Label2.visible = true
		Globals.scaleUp($Tutorial/Label2)

func _on_rally_module_on_selected() -> void:
	if not Globals.rallySelected and deselected:
		Globals.rallySelected = true
		await Globals.shrinkDown($Tutorial/Label2).finished
		$Tutorial/Label2.visible = false
		await get_tree().create_timer(1).timeout
		$Tutorial/Label3.visible = true
		Globals.scaleUp($Tutorial/Label3)
