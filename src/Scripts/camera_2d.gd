extends Camera2D

@export var speed: int

var mouse_down: bool = false
var last_mouse_pos: Vector2

var disabled: bool = false

func camera_movement():
	var offs = last_mouse_pos - get_global_mouse_position()
	offset += offs

func controls(delta: float) -> void:
	if Input.is_action_just_released("Scrollup"):
		last_mouse_pos = get_global_mouse_position()
		var zoom_amount = Vector2.ONE / 10
		zoom = (zoom + zoom_amount).min(Vector2.ONE * 3)
		camera_movement()

	if Input.is_action_just_released("Scrolldown"):
		last_mouse_pos = get_global_mouse_position()
		var zoom_amount = Vector2.ONE / 10
		zoom = (zoom - zoom_amount).max(Vector2.ONE * .3)
		camera_movement()

	if Input.is_action_just_pressed("Drag Camera"):
		mouse_down = true
		last_mouse_pos = get_global_mouse_position()
	if Input.is_action_just_released("Drag Camera"):
		mouse_down = false
	if mouse_down:
		camera_movement()
		
	var dir = Input.get_vector("Pan Left", "Pan Right", "Pan Up", "Pan Down").normalized()
	offset += dir * speed * delta

func _process(delta: float) -> void:
	if Globals.input_enabled:
		controls(delta)
	else:
		var mousePos: Vector2 = get_local_mouse_position()
		var dist: Vector2 = mousePos / Vector2(1280, 720)
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "offset", dist * 10, 0.5)
		tween.tween_property(self, "zoom", Vector2(1, 1), 0.5)
