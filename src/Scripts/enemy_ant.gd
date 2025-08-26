extends ant

func die():
	if nest:
		if self in nest.guards:
			nest.guards.erase(self)
		elif self in nest.ants:
			nest.ants.erase(self)
	$Sprite2D.texture = dead
	get_node("./GPUParticles2D").modulate = deadPartCol
	get_node("./GPUParticles2D").emitting = true
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	await tween.finished
	queue_free()

func _on_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("Ant"):
		eTargets.append(area.get_parent())
	if area.is_in_group("Nest"):
		eTargets.append(area.get_parent())

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Nest"):
		area.get_parent().damage()
		knockback()
