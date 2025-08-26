extends Node2D

signal spawn
signal levelComplete
signal gameComplete

@export var levelsUI: Node2D

var currentLevel: Node2D

var lvlSelected: int = 1

var levels: Array = [preload("res://src/Scenes/level_1.tscn"),
					 preload("res://src/Scenes/level_2.tscn"),
					 preload("res://src/Scenes/level_3.tscn"),
					 preload("res://src/Scenes/level_4.tscn"),
					 preload("res://src/Scenes/level_5.tscn"),
					 preload("res://src/Scenes/level_6.tscn"),
					 preload("res://src/Scenes/level_7.tscn"),
					 preload("res://src/Scenes/level_8.tscn")]

func changeLevelSelect():
	var pos = levelsUI.get_node("Level" + str(lvlSelected) + "/Nests/Nest").position + levelsUI.get_node("Level" + str(lvlSelected)).position
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Camera2D, "position", pos, 0.25)
	$UI/UI/LevelPicker/Label.text = "Level " + str(lvlSelected)

func spawnLevels():
	currentLevel.visible = false
	for i in range(0, levels.size()):
		var inst = levels[i].instantiate()
		inst.position.x = 2000 * i
		levelsUI.add_child(inst)
		if i > Globals.beaten:
			inst.modulate = Color(0.2, 0.2, 0.2)
	$Camera2D.position = levelsUI.get_node("Level" + str(lvlSelected) + "/Nests/Nest").position
	$Camera2D.offset = Vector2(0, 0)
	var tween = create_tween()
	tween.tween_property($Camera2D, "zoom", Vector2(0.8, 0.8), 0.25)

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
		if not Globals.lvl > Globals.beaten:
			Globals.beaten += 1

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
	$Camera2D.position = currentLevel.get_node("Nests/Nest").position
	$Camera2D.offset = Vector2(0, 0)

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

func _on_levels_pressed() -> void:
	spawnLevels()

func _on_right_pressed() -> void:
	if lvlSelected < levels.size():
		lvlSelected += 1
		changeLevelSelect()
		if lvlSelected - 1 > Globals.beaten:
			$UI/UI/LevelPicker/PlayLvlSelect.modulate = Color(0.5, 0.5, 0.5)
			$UI/UI/LevelPicker/PlayLvlSelect.disabled = true
			$UI/UI/LevelPicker/PlayLvlSelect/Juice.enabled = false

func _on_left_pressed() -> void:
	if lvlSelected > 1:
		lvlSelected -= 1
		changeLevelSelect()
		if not lvlSelected - 1 > Globals.beaten:
			$UI/UI/LevelPicker/PlayLvlSelect.modulate = Color(1, 1, 1)
			$UI/UI/LevelPicker/PlayLvlSelect.disabled = false
			$UI/UI/LevelPicker/PlayLvlSelect/Juice.enabled = true

func _on_play_lvl_select_pressed() -> void:
	Globals.lvl = lvlSelected - 1
	loadLevel(Globals.lvl)
	for i in $Levels.get_children():
		i.queue_free()
