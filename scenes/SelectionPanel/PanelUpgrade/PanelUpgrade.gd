tool
extends Panel

export(Upgrade.Type) var upgrade_type := Upgrade.Type.WEAPON setget set_updgrade_type
export var upgrade_id := -1 setget set_upgrade_id

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
	upgrade_id = max(-1,id)

	var upgrade

	match upgrade_type:
		Upgrade.Type.WEAPON:
			upgrade = Upgrade.WeaponRef.get(upgrade_id, false)
		Upgrade.Type.PERK:
			upgrade = Upgrade.PerkRef.get(upgrade_id, false)

	if upgrade:
		match upgrade_type:
			Upgrade.Type.WEAPON:
				$TextureRect.texture = upgrade.get(Upgrade.WeaponProperty.ICON)
			Upgrade.Type.PERK:
				$TextureRect.texture = upgrade.get(Upgrade.PerkProperty.ICON)
	else:
		upgrade_id = -1
		$TextureRect.texture = null

