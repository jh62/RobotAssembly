extends Area2D

signal on_line_started(position)

var pfind := AStar2D.new()

var _line_path : PoolVector2Array
var tilemap : TileMap

func _ready() -> void:
	pass

func initialize(available_tiles) -> void:
	pass

func _on_TextureButton_button_up() -> void:
	emit_signal("on_line_started", global_position)
