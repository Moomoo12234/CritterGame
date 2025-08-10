extends Node

@export var area: Node

var hover: bool = false

func mouse_entered() -> void:
	hover = true

func mouse_exited() -> void:
	hover = false

func _ready() -> void:
	area.connect("mouse_entered", self.mouse_entered)
	area.connect("mouse_exited", self.mouse_exited)
	#get_parent().connect("pressed", self.pressed)
