extends Panel

onready var label := $MarginContainer/HBoxContainer/Panel/MarginContainer2/Label
onready var upgrade_dropped := $MarginContainer/HBoxContainer/MarginContainer/UpgradePreview
onready var label_title := $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/LabelTitle
onready var labels = {
	"title": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/LabelTitle,
	"damage": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer1/Label1Value,
	"fire_rate": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/Label2Value,
	"critical": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer3/Label3Value,
	"cost": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer4/Label4Value,
	"time": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer5/Label5Value
}

var upgrade_installed := -1

func _ready() -> void:
	upgrade_dropped.connect("on_data_dropped", self, "_on_UpgradePreview_on_data_dropped")
	upgrade_dropped.upgrade_type = Upgrades.Type.WEAPON
	upgrade_dropped.upgrade_id = Player.MECH[Robots.Property.WEAPON]
	upgrade_dropped.update_preview()

# Obtiene el ID del upgrade que acaba de ser arrastrado al preview
func get_current_upgrade_id() -> int:
	return upgrade_dropped.upgrade_id

func _on_UpgradePreview_on_data_dropped() -> void:
	var current_upgrade := get_current_upgrade_id()
	upgrade_installed = current_upgrade
	update_preview()
	Signals.emit_signal("on_upgrade_installed", Upgrades.Type.WEAPON, upgrade_installed)

func update_preview() -> void:
	if upgrade_installed == -1:
		label_title.text = "No module selected"
		for label in labels.values():
			label.text = "0.0"
		return

	var weapon_ref : Dictionary = Upgrades.WeaponRef.get(upgrade_installed)

	label_title.text = str(weapon_ref[Upgrades.WeaponProperty.NAME])
	labels.get("damage").text = str(weapon_ref[Upgrades.WeaponProperty.DAMAGE])
	labels.get("fire_rate").text = str(weapon_ref[Upgrades.WeaponProperty.FIRE_RATE])
	labels.get("critical").text = str(weapon_ref[Upgrades.WeaponProperty.CRITICAL_CHANCE])
	labels.get("cost").text = str(weapon_ref[Upgrades.Property.COST])
	labels.get("time").text = str(weapon_ref[Upgrades.Property.PRODUCTION_TIME])
