extends Node

var beaten = 10

var input_enabled: bool = false
var lvl: int = 0
var played: bool =false
var paused: bool = false

var rallyPlaced: bool = false
var rallySelected: bool = false
var rallyMoved: bool = false
var rallyCreated: bool = false
var holeSelected: bool = false

func scaleUp(node: Node) -> Tween:
	node.scale = Vector2(0, 0)
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(node, "scale", Vector2(1, 1), 0.15)
	return tween

func shrinkDown(node: Node) -> Tween:
	node.scale = Vector2(1, 1)
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(node, "scale", Vector2(0, 0), 0.15)
	return tween
