extends MarginContainer

export var upgrade_type := Upgrades.Type.WEAPON

onready var label := $Panel/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer2/Label
onready var upgrade_dropped := $Panel/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/UpgradePreview
onready var button := $Panel/VBoxContainer/MarginContainer2/Button

var upgrade_installed := -1

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if get_current_upgrade_id() == -1:
		button.text = "No module selected"
		button.self_modulate = Color.white
	elif upgrade_installed == get_current_upgrade_id():
		button.text = "Remove"
		button.self_modulate = Color.darkgray
	else:
		button.text = "Install"
		button.self_modulate = Color.lightgreen

# Obtiene el ID del upgrade que acaba de ser arrastrado al preview
func get_current_upgrade_id() -> int:
	return upgrade_dropped.upgrade_id

func _on_UpgradePreview_on_data_dropped() -> void:
	var current_upgrade_id = get_current_upgrade_id()

	var t

	match upgrade_type:
		Upgrades.Type.WEAPON:
			var upgrade = Upgrades.WeaponRef[current_upgrade_id]

			t = "%s" % upgrade[Upgrades.WeaponProperty.NAME] + "\n" + "Damage: %s" % upgrade[Upgrades.WeaponProperty.DAMAGE] + "\n" + "Fire rate: %s" % upgrade[Upgrades.WeaponProperty.FIRE_RATE] + "\n" + "Crit. chance: %s" % upgrade[Upgrades.WeaponProperty.CRITICAL_CHANCE] + "%" + "\n" + "Cost: %s" % upgrade[Upgrades.Property.COST]  + "\n" + "Prod. time: %s" % upgrade[Upgrades.Property.PRODUCTION_TIME]
		Upgrades.Type.PERK:
			var upgrade = Upgrades.PerkRef[current_upgrade_id]

			t = "%s" % upgrade[Upgrades.PerkProperty.NAME] + "\n" + "Mobility: %s" % upgrade[Upgrades.PerkProperty.SPEED] + "\n" + "Armor: %s" % upgrade[Upgrades.PerkProperty.ARMOR]  + "\n" + "Cost: %s" % upgrade[Upgrades.Property.COST]  + "\n" + "Prod. time: %s" % upgrade[Upgrades.Property.PRODUCTION_TIME]

	if t:
		label.text = t


func _on_Button_button_up() -> void:
	if upgrade_installed == get_current_upgrade_id():
		upgrade_installed = -1
		upgrade_dropped.clear()
		Signals.emit_signal("on_upgrade_removed", upgrade_type, -1)
		return

	upgrade_installed = get_current_upgrade_id()
	Signals.emit_signal("on_upgrade_installed", upgrade_type, upgrade_installed)
