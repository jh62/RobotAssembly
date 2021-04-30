extends Node2D

onready var panel_weapons := $UI/PanelWeapons
onready var panel_perks := $UI/PanelPerks

func _ready() -> void:
	randomize()
	panel_weapons.set_upgrades(Player.available_weapons)
	panel_perks.set_upgrades(Player.available_perks)

	yield(get_tree().create_timer(5),"timeout")
	var amount = 100
	$Entities/BaseEnemy._on_build_requested(amount, Upgrades.Weapon.LASER_GUN, Upgrades.Perk.ARMOR_1, .34 * amount)

func _process(delta: float) -> void:
	pass

func _on_Button_button_up() -> void:
	get_tree().quit()
