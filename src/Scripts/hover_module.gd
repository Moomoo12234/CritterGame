extends Node

@export var area: Node

@export var rangeHover: bool
@export var range: float = 96

var hover: bool = false

func mouse_entered() -> void:
	hover = true

func mouse_exited() -> void:
	hover = false

func _process(delta: float) -> void:
	if get_parent().position.distance_to(get_parent().get_global_mouse_position()) < range and rangeHover:
		hover = true
	elif rangeHover:
		hover = false

func _ready() -> void:
	if not rangeHover:
		area.connect("mouse_entered", self.mouse_entered)
		area.connect("mouse_exited", self.mouse_exited)
	#get_parent().connect("pressed", self.pressed)
