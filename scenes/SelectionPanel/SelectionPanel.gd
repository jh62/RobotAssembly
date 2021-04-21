extends Panel

const PanelUpgrade := preload("res://scenes/SelectionPanel/PanelUpgrade/PanelUpgrade.tscn")

export var upgrade_type := Upgrades.Type.WEAPON

func _ready() -> void:
	yield(get_tree().create_timer(.01),"timeout")
	for panel in $MarginContainer/GridContainer.get_children():
		for upgrade_panel in panel.get_children():
			upgrade_panel.upgrade_type = upgrade_type

func set_upgrades(upgrades_id : Array) -> void:
	assert(upgrades_id.size() <= 6)

	for i in upgrades_id.size():
		var panel = $MarginContainer/GridContainer.get_child(i)
		panel.get_child(0).upgrade_id = upgrades_id[i]
