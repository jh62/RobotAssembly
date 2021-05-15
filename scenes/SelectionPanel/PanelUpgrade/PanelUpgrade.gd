tool
extends Panel

export(Upgrades.Type) var upgrade_type = Upgrades.Type.WEAPON setget set_updgrade_type
export var upgrade_id := 0 setget set_upgrade_id

func _ready() -> void:
	pass

func can_drop_data(position: Vector2, data) -> bool:
	return false

func get_drag_data(position: Vector2):
	if upgrade_id == -1:
		return null

	var drag_texture := TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = $TextureRect.texture
	drag_texture.rect_size = $TextureRect.rect_size

	var control := Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -.5 * drag_texture.rect_size

	var data = {
		"upgrade_type": upgrade_type,
		"upgrade_id": upgrade_id
#		"texture": drag_texture.texture
	}

	set_drag_preview(control)
	return data

func set_updgrade_type(type) -> void:
	upgrade_type = type
	set_upgrade_id(upgrade_id)

func set_upgrade_id(id : int) -> void:
	upgrade_id = clamp(id, -1, 999)

	var upgrade

	match upgrade_type:
		Upgrades.Type.WEAPON:
			upgrade = Upgrades.WeaponRef.get(upgrade_id, false)
		Upgrades.Type.PERK:
			upgrade = Upgrades.PerkRef.get(upgrade_id, false)

	if upgrade:
		match upgrade_type:
			Upgrades.Type.WEAPON:
				$TextureRect.texture = upgrade.get(Upgrades.WeaponProperty.ICON)
			Upgrades.Type.PERK:
				$TextureRect.texture = upgrade.get(Upgrades.PerkProperty.ICON)
	else:
		upgrade_id = -1
		$TextureRect.texture = null

