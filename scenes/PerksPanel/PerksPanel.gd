extends Panel

var upgrade_type = Upgrades.Type.PERK

onready var panels := $MarginContainer/VBoxContainer

func _ready() -> void:
	pass

func set_upgrades(upgrades_id : Array) -> void:
	assert(upgrades_id.size() <= 3)

	for i in upgrades_id.size():
		var panel = $MarginContainer/VBoxContainer.get_child(i)
		panel.upgrade_id = upgrades_id[i]
