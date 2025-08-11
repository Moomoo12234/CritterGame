extends ant

func die():
	if nest:
		nest.ants.erase(self)
	queue_free()

func _on_range_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Ant"):
		eTargets.append(area.get_parent())
	if area.is_in_group("Nest"):
		eTargets.append(area.get_parent())

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Nest"):
		knockback()
