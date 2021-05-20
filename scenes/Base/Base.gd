extends Area2D
class_name Base

signal on_mech_spawned(node)

const HITPOINTS_BAR_POS_ENEMY := Vector2(-24,-32)
const HITPOINTS_BAR_POS_PLAYER := Vector2(-24,24)

const MECH := preload("res://scenes/Mech/Mech_v2.tscn")

export(Side.Team) var side
export var hitpoints := 1000.0
export var is_active := true setget set_active
export var production_rate := .01

var order : Order
var order_time := 0.0
var production_queue = []

func _ready() -> void:
	add_to_group(Groups.GROUP_BASE)
	$Sprite/ProgressBar.max_value = hitpoints
	$Sprite/ProgressBar.value = hitpoints
	$Sprite/ProgressBar.step = 0.1
	set_active(is_active)

	match side:
		Side.TEAM_PLAYER:
			$Sprite/ProgressBar.rect_position = HITPOINTS_BAR_POS_PLAYER
			Signals.connect("on_build_requested", self, "_on_build_requested")
			Signals.connect("on_build_cancel", self, "_on_build_cancel")
		Side.TEAM_ENEMY:
			$Sprite/ProgressBar.rect_position = HITPOINTS_BAR_POS_ENEMY

#	$Timer_Production.start(production_rate)

func _process(delta: float) -> void:
	$Sprite/ProgressBar.value = hitpoints

	if !is_active:
		return
	if production_queue.empty() && order == null:
		return

	if order != null:
		if !order.is_done():
			order.update(delta)
			if side == Side.TEAM_PLAYER:
				Signals.emit_signal("on_queue_step", order.build_time)
			return
	else:
		order = production_queue.front()
		return

#	var blueprint = order.get("blueprint")
#	var weapon = order.get(Upgrades.Type.WEAPON, -1)
#	var perk = order.get(Upgrades.Type.PERK, -1)

	var mech = MECH.instance()
	mech.side = side
	mech.initialize(order.blueprint, order.weapon_id, order.perk_id)

	order = null
	production_queue.pop_front()

	emit_signal("on_mech_spawned", mech)

	if side == Side.TEAM_PLAYER:
		Signals.emit_signal("on_order_completed", production_queue.size())

func on_attacked_by(attacker) -> void:
	hitpoints = max(hitpoints - attacker.damage, 0.0)

func set_active(active : bool) -> void:
	is_active = active

func _on_build_requested(blueprint : Dictionary, amount : int, weapon : int, perk : int, time : float) -> void:
	var rest = Constants.MAX_PRODUCTION_QUEUE - production_queue.size()
	var to_make = min(amount, rest)

	if !to_make:
		return

	var production_rate = time / to_make

	if weapon == -1:
		weapon = blueprint.get(Robots.Property.WEAPON)

	if perk == -1:
		perk = blueprint.get(Robots.Property.PERK)

	for i in to_make:
		var o := Order.new()
		o.blueprint = blueprint
		o.weapon_id = weapon
		o.perk_id = perk
		o.production_time = production_rate

#		var order = {
#			"blueprint": blueprint,
#			Upgrades.Type.WEAPON: weapon,
#			Upgrades.Type.PERK: perk,
#			Upgrades.Property.PRODUCTION_TIME: production_rate
#		}
		production_queue.append(o)

	if side == Side.TEAM_PLAYER:
		Signals.emit_signal("on_build_begin", production_queue.size(), production_rate)

class Order:
	var build_time := 0.0

	var blueprint
	var weapon_id
	var perk_id
	var production_time

	func update(delta) -> void:
		build_time += delta

	func is_done()->bool:
		return build_time >= production_time
