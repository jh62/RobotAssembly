extends Node2D

onready var panel_weapons := $UI/PanelWeapons
onready var panel_perks := $UI/PanelPerks

func _ready() -> void:
	randomize()
	panel_weapons.set_upgrades(Player.available_weapons)
	panel_perks.set_upgrades(Player.available_perks)

	yield(get_tree().create_timer(1),"timeout")
	var amount = 30
	var production_time = Robots.MECH_I.get(Robots.Property.PRODUCTION_TIME)
	$Entities/BaseEnemy._on_build_requested(Robots.MECH_I, amount, -1, -1, production_time * amount)

func _process(delta: float) -> void:
	pass

func _on_Button_button_up() -> void:
	get_tree().quit()
