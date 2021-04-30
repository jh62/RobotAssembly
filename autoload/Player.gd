extends Node

const available_weapons := [0, 1,2,3]
const available_perks := [0,1,2,3,4,5]

var funds := 500
var active_weapon := -1
var active_perk := -1

func _ready() -> void:
	Signals.connect("on_upgrade_installed", self, "_on_upgrade_changed")
	Signals.connect("on_upgrade_removed", self, "_on_upgrade_changed")
	Signals.connect("on_PowerModule_collected", self, "_on_PowerModule_collected")

func _on_upgrade_changed(upgrade_type, upgrade_id) -> void:
	match upgrade_type:
		Upgrades.Type.WEAPON:
			active_weapon = upgrade_id
		Upgrades.Type.PERK:
			active_perk = upgrade_id

func _on_PowerModule_collected(amount : int) -> void:
	funds += amount
	print_debug("reached")
