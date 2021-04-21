extends Panel

signal on_data_dropped

var upgrade_id := -1

func _ready() -> void:
	pass

func can_drop_data(position: Vector2, data) -> bool:
	return owner.upgrade_type == data["upgrade_type"]

func get_drag_data(position: Vector2):
	pass

func drop_data(position: Vector2, data) -> void:
	$TextureRect.texture = data["texture"]
	upgrade_id = data["upgrade_id"]
	emit_signal("on_data_dropped")
