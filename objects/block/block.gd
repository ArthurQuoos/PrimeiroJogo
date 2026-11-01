extends StaticBody2D

signal bumped

@onready var visual: ColorRect = $Visual
var used := false
var rest_y: float

func _ready() -> void:
	rest_y = visual.position.y

func bump() -> void:
	if used:
		return
	used = true
	visual.color = Color("8b5a2b")
	bumped.emit()
	var tween := create_tween()
	tween.tween_property(visual, "position:y", rest_y - 10.0, 0.08)
	tween.tween_property(visual, "position:y", rest_y, 0.08)
