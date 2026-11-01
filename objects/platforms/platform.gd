@tool
extends StaticBody2D

@export var size: Vector2 = Vector2(200, 24):
	set(value):
		size = value
		_update_shape()

func _ready() -> void:
	_update_shape()

func _update_shape() -> void:
	if not is_node_ready():
		return
	$Visual.size = size
	$Visual.position = -size / 2.0
	$Visual.color = Color("4a8c3f")
	var rect := RectangleShape2D.new()
	rect.size = size
	$Shape.shape = rect
