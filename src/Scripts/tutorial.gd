extends Control

var started: bool = false

func _process(delta: float) -> void:
	if Globals.input_enabled and not started:
		started = true
		$Label.visible = true
		Globals.scaleUp($Label)

func _on_hole_selected() -> void:
	if not Globals.holeSelected:
		Globals.holeSelected =true
		await Globals.shrinkDown($Label).finished
		$Label.visible = false
		$Label2.visible = true
		Globals.scaleUp($Label)
		await get_tree().create_timer(10).timeout
		await Globals.shrinkDown($Label2).finished
		$Label2.visible = false
		$Label3.visible = true
		Globals.scaleUp($Label3)
		await get_tree().create_timer(10).timeout
		await Globals.shrinkDown($Label3).finished
		$Label3.visible = false
