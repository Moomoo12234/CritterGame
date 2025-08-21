extends Node2D

signal spawn
signal levelComplete
signal gameComplete

var currentLevel: Node2D

var hp: int = 10

var levels: Array = [load("res://src/Scenes/level_1.tscn"),
					 load("res://src/Scenes/level_2.tscn"),
					 load("res://src/Scenes/level_3.tscn"),
					 load("res://src/Scenes/level_4.tscn"),
					 load("res://src/Scenes/level_5.tscn")]

func checkDead():
	if currentLevel.get_node("FriendlyAnts").get_child_count() < 1:
		pass
func checkCompleted():
	if currentLevel.get_node("Nests").get_child_count() < 2 and currentLevel.get_node("Nests/Nest") and Globals.input_enabled:
		if not Globals.lvl >= levels.size() - 1:
			emit_signal("levelComplete")
		else:
			emit_signal("gameComplete")
		Globals.input_enabled = false
		$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1)
		$AudioStreamPlayer.play()

func onSpawn():
	emit_signal("spawn")

func loadLevel(level: int) -> void:
	if currentLevel:
		currentLevel.queue_free()
	Globals.lvl = level
	var lvlInst = levels[level].instantiate()
	add_child(lvlInst)
	connectLevel(lvlInst)

func connectLevel(lvl: Node2D):
	currentLevel = lvl
	$UI/UI.currentLevel = currentLevel
	currentLevel.get_node("Nests/Nest").connect("spawn", onSpawn)
	currentLevel.get_node("Nests/Nest").connect("die", $UI/UI.die)

func _ready() -> void:
	loadLevel(Globals.lvl)
	Globals.input_enabled = false
	if Globals.played:
		Globals.input_enabled=true
		Globals.played = true
		$UI/UI.restart()

func _process(delta: float) -> void:
	if currentLevel:
		$UI/UI/MainHud/Label.text = str(currentLevel.get_child_count())
	
		checkCompleted()
	
	if Input.is_action_just_pressed("Pause"):
		Globals.paused = true
		Globals.input_enabled = false
		$UI/UI.pause()

func _on_next_level_pressed() -> void:
	loadLevel(Globals.lvl + 1)
	Globals.input_enabled = true
