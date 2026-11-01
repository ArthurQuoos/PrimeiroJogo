extends Node2D

var coins := 0
@onready var coin_label: Label = $CoinLabel

func _ready() -> void:
	for block in get_tree().get_nodes_in_group("blocks"):
		block.bumped.connect(_on_block_bumped)

func _on_block_bumped() -> void:
	coins += 1
	coin_label.text = "Moedas: %d" % coins
