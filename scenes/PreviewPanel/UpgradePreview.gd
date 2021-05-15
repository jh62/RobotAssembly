extends Panel

signal on_data_dropped

var upgrade_type : int
var upgrade_id : int

func _ready() -> void:
	pass

func can_drop_data(position: Vector2, data) -> bool:
	return upgrade_type == data["upgrade_type"] && data["upgrade_id"] != upgrade_id

func get_drag_data(position: Vector2):
	if upgrade_id == -1:
		return
	else:
		upgrade_id = -1

	update_preview()

func drop_data(position: Vector2, data) -> void:
#	$TextureRect.texture = data["texture"]
#	emit_signal("on_data_dropped")
	upgrade_type = data["upgrade_type"]
	upgrade_id = data["upgrade_id"]
	update_preview()

func update_preview() -> void:
	if upgrade_id == -1:
		$TextureRect.texture = null
	else:
		match upgrade_type:
			Upgrades.Type.WEAPON:
				$TextureRect.texture = Upgrades.WeaponRef[upgrade_id][Upgrades.WeaponProperty.ICON]
			Upgrades.Type.PERK:
				$TextureRect.texture = Upgrades.PerkRef[upgrade_id][Upgrades.PerkProperty.ICON]

	emit_signal("on_data_dropped")
