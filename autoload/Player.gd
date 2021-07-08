extends Node

signal on_funds_changed

const available_weapons := []
const available_perks := [Upgrade.Perk.ARMOR_1]

var MECH = {
	Robots.Property.HITPOINTS: 30,
	Robots.Property.SPEED: 24,
	Robots.Property.DAMAGE: 0,
	Robots.Property.FIRE_RATE: 0,
	Robots.Property.CRIT_CHANCE: 0,
	Robots.Property.WEAPON: Upgrades.Weapon.MACHINE_GUN,
	Robots.Property.PERK: -1,
	Robots.Property.WEAKNESSES: [],
	Robots.Property.PRODUCTION_COST: 0,
	Robots.Property.PRODUCTION_TIME: 2.0
}

# Player options
var upgrades_visible := true
var funds := 500 setget set_funds
var powermodules := 0

var active_weapon := -1
var active_perk := -1

func _ready() -> void:
	Signals.connect("on_upgrade_installed", self, "_on_upgrade_changed")
	Signals.connect("on_upgrade_removed", self, "_on_upgrade_changed")
	Signals.connect("on_PowerModule_collected", self, "_on_PowerModule_collected")
	Signals.connect("on_PowerModule_consumed", self, "_on_PowerModule_consumed")

	yield(get_tree(),"idle_frame")
	emit_signal("on_funds_changed")

func _on_upgrade_changed(upgrade_type, upgrade_id) -> void:
	match upgrade_type:
		Upgrades.Type.WEAPON:
			active_weapon = upgrade_id
		Upgrades.Type.PERK:
			active_perk = upgrade_id

func _on_PowerModule_collected() -> void:
	powermodules += 1

func _on_PowerModule_consumed() -> void:
	powermodules = max(powermodules - 1, 0)

func set_funds(new_value) -> void:
	funds = clamp(new_value, 0, 999999)
	emit_signal("on_funds_changed")
