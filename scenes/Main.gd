extends Node2D

onready var panel_weapons := $UI/Control/PanelWeapons
onready var panel_perks := $UI/Control/PanelPerks

func _ready() -> void:
	Signals.connect("on_enemy_funds_increase",self,"_on_enemy_funds_increase")
	$Entities.connect("on_mech_spawned", $Map/TileMap, "_on_Entities_on_mech_spawned")
	randomize()
	panel_weapons.set_upgrades(Player.available_weapons)
	panel_perks.set_upgrades(Player.available_perks)

func _process(delta: float) -> void:
	pass

func _on_Button_button_up() -> void:
	get_tree().quit()

func _on_TimerCredits_timeout() -> void:
	var fund_increase := 30
#	var cost := Upgrade.get_weapon_cost(Player.MECH.get(Robots.Property.WEAPON)) + Upgrade.get_perk_cost(Player.MECH.get(Robots.Property.PERK))
	Player.funds += fund_increase
	$Entities/BaseEnemy.base_ai.funds += fund_increase * 1.5

func _on_enemy_funds_increase(amount) -> void:
	$Entities/BaseEnemy.base_ai.funds += amount
