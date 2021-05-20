extends Panel

onready var label := $MarginContainer/HBoxContainer/Panel/MarginContainer2/Label
onready var upgrade_dropped := $MarginContainer/HBoxContainer/MarginContainer/UpgradePreview
onready var label_title := $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/LabelTitle
onready var labels = {
	"mobility": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer1/Label1Value,
	"armor": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer2/Label2Value,
	"cost": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer3/Label3Value,
	"time": $MarginContainer/HBoxContainer/Panel/MarginContainer2/VBoxContainer/HBoxContainer4/Label4Value
}

var upgrade_installed := -1

func _ready() -> void:
	upgrade_dropped.connect("on_data_dropped", self, "_on_UpgradePreview_on_data_dropped")
	upgrade_dropped.upgrade_type = Upgrades.Type.PERK
	upgrade_dropped.upgrade_id = Player.MECH[Robots.Property.PERK]
	upgrade_dropped.update_preview()

# Obtiene el ID del upgrade que acaba de ser arrastrado al preview
func get_current_upgrade_id() -> int:
	return upgrade_dropped.upgrade_id

func _on_UpgradePreview_on_data_dropped() -> void:
	var current_upgrade := get_current_upgrade_id()
	upgrade_installed = current_upgrade
	update_preview()
	Signals.emit_signal("on_upgrade_installed", Upgrades.Type.PERK, upgrade_installed)

func update_preview() -> void:
	var title_text : String
	var mobility_text : String
	var armor_text : String
	var cost_text : String
	var time_text : String

	if upgrade_installed == -1:
		title_text = "No module selected"
		mobility_text = "0.0"
		armor_text = "0.0"
		cost_text = "0.0"
		time_text = "0.0"
	else:
		var perk_ref : Dictionary = Upgrades.PerkRef.get(upgrade_installed)

		title_text = str(perk_ref[Upgrades.PerkProperty.NAME])
		mobility_text = str(perk_ref[Upgrades.PerkProperty.SPEED])
		armor_text = str(perk_ref[Upgrades.PerkProperty.ARMOR])
		cost_text = str(perk_ref[Upgrades.Property.COST])
		time_text = str(perk_ref[Upgrades.Property.PRODUCTION_TIME])

	label_title.text = title_text
	labels.get("mobility").text = mobility_text
	labels.get("armor").text = armor_text
	labels.get("cost").text = cost_text
	labels.get("time").text = time_text
