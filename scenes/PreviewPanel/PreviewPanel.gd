extends MarginContainer

export var upgrade_type := Upgrades.Type.WEAPON

onready var label := $Panel/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/Label
onready var upgrade_prev := $Panel/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/UpgradePreview

func _ready() -> void:
	pass

func _on_UpgradePreview_on_data_dropped() -> void:
	var t

	match upgrade_type:
		Upgrades.Type.WEAPON:
			var upgrade = Upgrades.WeaponRef[upgrade_prev.upgrade_id]

			t = "%s" % upgrade[Upgrades.WeaponProperty.NAME] + "\n" + "Damage: %s" % upgrade[Upgrades.WeaponProperty.DAMAGE] + "\n" + "Fire rate: %s" % upgrade[Upgrades.WeaponProperty.FIRE_RATE] + "\n" + "Critical chance: %s" % upgrade[Upgrades.WeaponProperty.FIRE_RATE] + "%"
		Upgrades.Type.PERK:
			var upgrade = Upgrades.PerkRef[upgrade_prev.upgrade_id]

			t = "%s" % upgrade[Upgrades.PerkProperty.NAME] + "\n" + "Mobility: %s" % upgrade[Upgrades.PerkProperty.SPEED] + "\n" + "Armor: %s" % upgrade[Upgrades.PerkProperty.ARMOR]

	if t:
		label.text = t
