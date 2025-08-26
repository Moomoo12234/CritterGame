extends Node

signal onSelected
signal deselected

@export var enemy: bool

@export var HoverModule: Node
@export var lbl: Label
@export var minus: TextureButton
@export var plus: TextureButton

var assignedAnts: Array = []
var assignedAntsNum: int = 0
var antsNeeded: int = 0
var assignable: bool = true

var selected: bool = false

@export var rad: int = 64
@export var minRad: int = 0

func clear()-> void:
	for i in assignedAnts:
		if i:
			removeAnt(i)

func subtract() -> void:
	if Input.is_action_pressed("ctrl"):
		assignedAntsNum -= 5
	elif Input.is_action_pressed("shift"):
		assignedAntsNum -= 10
	else:
		assignedAntsNum -= 1
	
	if assignedAntsNum < 0:
		assignedAntsNum = 0

func add() -> void:
	if Input.is_action_pressed("ctrl"):
		assignedAntsNum += 5
	elif Input.is_action_pressed("shift"):
		assignedAntsNum += 10
	else:
		assignedAntsNum += 1

func removeAnt(i: Node, death: bool = false) -> void:
	if not death:
		i.unassign()
	assignedAnts.erase(i)

func addAnt(ant) -> void:
	assignedAnts.append(ant)

func _ready():
	if not enemy:
		minus.connect("pressed", subtract)
		plus.connect("pressed", add)

func _process(delta: float) -> void:
	if not enemy:
		if assignedAntsNum < assignedAnts.size() or not assignable and assignedAnts.size() > 0:
			removeAnt(assignedAnts[0])
		
		antsNeeded = assignedAntsNum - assignedAnts.size()
		
		if Globals.input_enabled and assignable:
			if Input.is_action_just_pressed("Select") and HoverModule.hover:
				selected = true
				emit_signal("onSelected")
				lbl.visible = true
			elif Input.is_action_just_pressed("Select") and not HoverModule.hover:
				selected = false
				emit_signal("deselected")
				lbl.visible = false
		
		lbl.text = str(assignedAntsNum)
