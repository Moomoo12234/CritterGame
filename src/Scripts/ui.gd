extends Control

@export var rally: PackedScene

@export var rallyContainer: Node2D
@export var antContainer: Node2D
@export var camera: Camera2D

@export var delay: float = 0.3

var currentLevel: Node2D

func pause() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($MainHud, "position", Vector2(-1280, 0), delay)
	tween.tween_property($PauseMenu, "position", Vector2(0, 0), delay)

func restart() -> void:
	$DeathMenu.position.x = 0
	$MainMenu.position.x = 1280
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($MainHud, "position", Vector2(0, 0), delay)
	tween.tween_property($DeathMenu, "position", Vector2(1280, 0), delay)

func _process(delta: float) -> void:
	$MainHud/Label.text = str(currentLevel.get_node("Ants").get_child_count())
	if Globals.input_enabled:
		$MainHud/AntBar.value = currentLevel.get_node("Nests/Nest").food
		var tween = create_tween()
		tween.tween_property($MainHud/AntBar, "value", currentLevel.get_node("Nests/Nest").food, 0.25)
		if currentLevel.get_node("Ants").get_child_count() > 15 and not Globals.rallyCreated:
			$MainHud/Label2.visible = true
			Globals.scaleUp($MainHud/Label2)

func _on_rally_btn_pressed() -> void:
	var rallyInst = rally.instantiate()
	currentLevel.get_node("Rallys").add_child(rallyInst)
	
	Globals.rallyCreated = true
	await Globals.shrinkDown($MainHud/Label2).finished
	$MainHud/Label2.visible = false

func _on_main_spawn() -> void:
	$MainHud/AntBar/AnimationPlayer.play("Spawn")

func _on_main_level_complete() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($CompleteLevel, "position", Vector2(0, 0), delay)
	tween.tween_property($MainHud, "position", Vector2(-1280, 0), delay)

func _on_next_level_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($MainHud, "position", Vector2(0, 0), delay)
	tween.tween_property($CompleteLevel, "position", Vector2(1280, 0), delay)
	#$MainHud.position.x = 0
	#$CompleteLevel.position.x = 1280

func _on_play_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MainHud, "position", Vector2(0, 0), delay)
	tween.tween_property($MainMenu, "position", Vector2(-1280, 0), delay)
	Globals.input_enabled=true
	Globals.played = true

func die() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($DeathMenu, "position", Vector2(0, 0), delay)
	tween.tween_property($MainHud, "position", Vector2(1280, 0), delay)
	$MainHud.position.x = 1280
	$DeathMenu.position.x = 0
	Globals.input_enabled = false

func _on_main_menu_pressed() -> void:
	Globals.played = false
	Globals.lvl = 0
	get_tree().reload_current_scene()

func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_game_complete() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($MainHud, "position", Vector2(1280, 0), delay)
	tween.tween_property($CompleteGame, "position", Vector2(0, 0), delay)

func _on_pause_play_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($PauseMenu, "position", Vector2(1280, 0), delay)
	tween.tween_property($MainHud, "position", Vector2(0, 0), delay)
	Globals.paused = false
	Globals.input_enabled = true

func _on_pause_main_menu_pressed() -> void:
	Globals.played = false
	Globals.paused = false
	get_tree().reload_current_scene()

func _on_levels_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($MainMenu, "position", Vector2(1280, 0), delay)
	tween.tween_property($LevelPicker, "position", Vector2(0, 0), delay)
	Globals.paused = true

func _on_play_lvl_select_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MainHud, "position", Vector2(0, 0), delay)
	tween.tween_property($LevelPicker, "position", Vector2(-1280, 0), delay)
	Globals.input_enabled=true
	Globals.paused = false
	Globals.played = true

func _on_back_pressed() -> void:
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MainMenu, "position", Vector2(0, 0), delay)
	tween.tween_property($LevelPicker, "position", Vector2(-1280, 0), delay)
	await tween.finished
	Globals.paused = false
	get_tree().reload_current_scene()

func _on_music_pressed() -> void:
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))

func _on_sound_pressed() -> void:
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))
