extends Panel

var upgrade_type = Upgrades.Type.WEAPON

onready var panels := $MarginContainer/GridContainer

func _ready() -> void:
	pass

func set_upgrades(upgrades_id : Array) -> void:
	assert(upgrades_id.size() <= 6)

	for i in upgrades_id.size():
		var panel = $MarginContainer/GridContainer.get_child(i)
		panel.upgrade_id = upgrades_id[i]
