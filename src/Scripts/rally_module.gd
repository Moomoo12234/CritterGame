extends Node

var ants: Node2D

@export var HoverModule: Node
@export var lbl: Label

var assignedAnts: Array = []
var assignedAntsNum: int = 1
@export var rad: int = 64
@export var minRad: int = 0

func removeAnt() -> void:
	assignedAnts[0].unassign()
	assignedAnts.erase(assignedAnts[0])

func addAnt() -> void:
	var freeAnts = ants.get_children()
	
	if freeAnts.size() > 0:
		freeAnts[0].assign(self)
		assignedAnts.append(freeAnts[0])

func _process(delta: float) -> void:
	#print(assignedAnts)
	if Input.is_action_just_pressed("Scrollup") and HoverModule.hover:
		assignedAntsNum += 1
	if Input.is_action_just_pressed("Scrolldown") and HoverModule.hover and assignedAntsNum > 0:
		assignedAntsNum -= 1
	
	if assignedAntsNum > assignedAnts.size():
		addAnt()
	
	if assignedAntsNum < assignedAnts.size():
		removeAnt()
	
	lbl.text = str(assignedAntsNum)
	
	if not lbl.visible == HoverModule.hover:
		lbl.visible = not lbl.visible
