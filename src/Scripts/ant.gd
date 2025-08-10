extends CharacterBody2D

enum STATES {
	IDLE,
	COLLECTING,
	ATTACKING
}

var state: STATES = STATES.IDLE

@export var empty: Texture2D
@export var full: Texture2D

@export var speed: int
@export var accelVector: float
@export var moveRange: int
@export var rally: Node

var freeAnts: Node2D
var ants: Node2D
var nest: Node2D

var target: Vector2

var reachedTarget: bool = false
var assigned: bool = false
var hasFood: bool = false

func deliverFood() -> void:
	$Sprite2D.texture = empty
	if rally:
		pickTarget(rally)
	else:
		unassign()
	hasFood = false

func collectFood():
	$Sprite2D.texture = full
	target = nest.position
	hasFood = true

func unassign():
	assigned = false
	rally = nest
	
	get_parent().remove_child(self)
	freeAnts.add_child(self)

func assign(r: Node):
	assigned = true
	rally = r
	get_parent().remove_child(self)
	ants.add_child(self)

func move(dt: float):
	var angle = position.angle_to_point(target)
	rotation = lerp_angle(rotation, angle, 0.2)
	if angle - rotation < 0.005 and angle - rotation > -0.05:
		rotation = angle
	accelVector = lerp(accelVector, 1.0, 0.05)
	if 1 - accelVector < 0.05:
		accelVector = 1
	
	var dir = Vector2(cos(rotation), sin(rotation))
	velocity = dir * speed * dt * accelVector
	if position.distance_to(target) < 8:
		velocity = Vector2(0, 0)
		reachedTarget = true

	move_and_slide()

func pickTarget(rally: Node):
	var clamp: Vector2 = Vector2(32, 32)
	var res: Vector2 = Vector2(1280, 720)
	var minRange: int = 64
	
	var dir = randi_range(0, 359)
	dir = Vector2(cos(deg_to_rad(dir)), sin(deg_to_rad(dir)))
	dir *= randi_range(rally.minRad, rally.rad)
	if assigned:
		target = dir + rally.get_parent().position
	else:
		target = dir + rally.position
	if target.x > res.x - clamp.x:
		target.x = res.x - clamp.x
	elif target.x < 0 + clamp.x:
		target.x = clamp.x
	
	if target.y > res.y - clamp.y:
		target.y = res.y - clamp.y
	elif target.y < 0 + clamp.y:
		target.y = clamp.y
		
	accelVector = 0.0

func _ready() -> void:
	pickTarget(rally)

func _process(delta: float) -> void:
	move(delta)

func _on_move_timer_timeout() -> void:
	if reachedTarget and state == STATES.IDLE:
		reachedTarget = false
		pickTarget(rally)
