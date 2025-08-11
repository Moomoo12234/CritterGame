extends Node

@onready var parent = get_parent()
@onready var scale = parent.scale

@export var scaleFactor: float = 2
@export var delay: float = 0.05

@export var clickJuice: bool = false
@export var hoverSound: bool = true
@export var rotJuice: bool = true

func pressed() -> void:
	if clickJuice:
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
		tween.tween_property(parent ,"scale", Vector2(scaleFactor + 0.2, scaleFactor + 0.2), delay).set_ease(Tween.EASE_OUT)
		tween.chain().tween_property(parent,"scale", Vector2(scaleFactor, scaleFactor), delay).set_ease(Tween.EASE_IN)
		if $Click:
			$Click.pitch_scale = randf_range(1.0, 1.1)
			$Click.play()

func mouse_entered() -> void:
	var tween = create_tween().parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent, "scale", Vector2(scaleFactor, scaleFactor), delay)
	if rotJuice:
		tween.tween_property(parent, "rotation", -1 * deg_to_rad(2 * scaleFactor), delay)
	#parent.scale = Vector2(scaleFactor, scaleFactor)
	#parent.rotation -= deg_to_rad(2 * scaleFactor)
	if $Hover and hoverSound:
		$Hover.pitch_scale = randf_range(0.9, 1)
		$Hover.play()

func mouse_exited() -> void:
	var tween = create_tween().parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(parent, "scale", Vector2(scale.x, scale.y), delay)
	if rotJuice:
		tween.tween_property(parent, "rotation", 0, delay)
	#parent.scale = Vector2(1, 1)
	#parent.rotation += deg_to_rad(2 * scaleFactor)

func _ready() -> void:
	get_parent().connect("mouse_entered", self.mouse_entered)
	get_parent().connect("mouse_exited", self.mouse_exited)
	get_parent().connect("pressed", self.pressed)
