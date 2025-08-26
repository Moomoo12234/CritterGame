extends CharacterBody2D
class_name ant

@export var dead: Texture2D

@export var nest: Node2D

@export var navigation2D: NavigationAgent2D
var navPos:Vector2

@export var speed: int
@export var moveRange: int
@export var hp: int = 1
@export var rally: Node

var accelVector: float = 1
var assigned: bool = false
var reachedTarget: bool = false
var combat: bool = false

var prevTarget: Vector2

var eTargets = []

var updateIndex = randi_range(0, 1)
var updateNum = 0
func knockback():
	accelVector = -10

func die():
	if rally:
		if rally.has_method("removeAnt"):
			rally.removeAnt(self, true)
	$Sprite2D.texture = dead
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	await tween.finished
	queue_free()

func damage():
	hp -= 1
	knockback()

func updateTarget() -> void:
	reachedTarget = false
	if rally:
		pickTarget(rally)
	else:
		unassign()

func assign(r: Node):
	assigned = true
	rally = r

func unassign():
	assigned = false
	rally = nest
	reachedTarget = false

func pickTarget(rally: Node):
	var clamp: Vector2 = Vector2(32, 32)
	var res: Vector2 = Vector2(1280, 720)
	var minRange: int = 64
	
	var dir = randi_range(0, 359)
	dir = Vector2(cos(deg_to_rad(dir)), sin(deg_to_rad(dir)))
	dir *= randi_range(rally.minRad, rally.rad)
	if "position" in rally:
		navigation2D.target_position = dir + rally.position
	else:
		navigation2D.target_position = dir + rally.get_parent().position

func move(dt: float):
	#var angle = position.angle_to_point(target)
	#var angle = position.angle_to_point(navigation2D.get_next_path_position())
	#rotation = lerp_angle(rotation, angle, 0.2)
	#if angle - rotation < 0.005 and angle - rotation > -0.05:
	#	rotation = angle
	#accelVector = lerp(accelVector, 1.0, 0.3)
	#if 1 - accelVector < 0.05:
	#	accelVector = 1
	#true
	#var dir = Vector2(cos(rotation), sin(rotation))
	#velocity = dir * speed * dt * accelVector
	#if position.distance_to(navigation2D.targ) < 8:
		#velocity = Vector2(0, 0)
	#reachedTarget = navigation2D.is_target_reached()
	
	#look_at(navigation2D.get_next_path_position())
	if updateIndex == updateNum:
		navPos = navigation2D.get_next_path_position()
	var i  = clamp(10.0 * dt, 0, 1)
	rotation = lerp_angle(rotation, position.angle_to_point(navPos), i)
	
	accelVector = lerp(accelVector, 1.0,  10.0 * dt)
	if 1 - accelVector < 0.05:
		accelVector = 1
	
	var dir = Vector2(cos(rotation), sin(rotation))
	velocity = dir * speed * dt * accelVector
	
	if navigation2D.is_target_reached():
		#print("bussin")
		velocity = Vector2(0, 0)
		reachedTarget = true
	
	move_and_slide()

func _ready() -> void:
	#nest.rallyModule.addAnt(self)
	#assign(nest)
	pickTarget(rally)
	$MoveTimer.start(randf_range(0.5, 1.5))
	navPos = navigation2D.get_next_path_position()
	
	nest.connect("die", die)

func process() -> void:
	pass

func _process(delta: float) -> void:
	if updateNum == 0:
		updateNum = 1
	elif updateNum == 1:
		updateNum = 0
	if hp >0 and not Globals.paused:
		move(delta)
		
		if eTargets.size() > 0:
			
			prevTarget = navigation2D.target_position
			if eTargets[0]:
				reachedTarget = false
				navigation2D.target_position = eTargets[0].position
			else:
				eTargets.remove_at(0)
	
	if hp <= 0:
		die()
	
	#print("target", navigation2D.target_position)
	#print("pos", position)
	
	process()

func _on_move_timer_timeout() -> void:
	if not Globals.paused:
		if not nest:
			die()

		if reachedTarget and rally or not navigation2D.is_target_reachable():
			if combat and prevTarget:
				navigation2D.target_position = prevTarget
				combat = false
			else:
				updateTarget()
	$MoveTimer.start(randi_range(1, 5))
