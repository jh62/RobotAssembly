extends Node

const available_weapons := [1,2,3]
const available_perks := [0,1,2,3,4,5]

var production_quantity := 10
var active_weapon := -1
var active_perk := -1

func _ready() -> void:
	Signals.connect("on_quantity_changed", self, "_on_quantity_changed")

func on_quantity_changed(amount : int) -> void:
	production_quantity = amount
