extends Node2D

onready var panel_weapons := $UI/PanelWeapons
onready var panel_perks := $UI/PanelPerks

func _ready() -> void:
	randomize()
	panel_weapons.set_upgrades(Player.available_weapons)
	panel_perks.set_upgrades(Player.available_perks)

func _process(delta: float) -> void:
	pass

func _on_Button_button_up() -> void:
	get_tree().quit()
