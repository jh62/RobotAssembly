extends Area2D
class_name Base

signal on_mech_spawned(node)

const HITPOINTS_BAR_POS_ENEMY := Vector2(-24,-32)
const HITPOINTS_BAR_POS_PLAYER := Vector2(-24,24)
const MAX_COMPLETED_QUEUE := 3

const MECH := preload("res://scenes/Mech/Mech_v2.tscn")

export(Side.Team) var side
export var hitpoints := 1000.0
export var is_active := true setget set_active
export var production_rate := .01
export var unit_release_delay := .5

var order : Order
var order_time := 0.0
var production_queue = []
var completed_queue = []
var production_halted := false

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

			$Sprite/ProgressBar2.step = 1
			$Sprite/ProgressBar2.value = 0
			$Sprite/ProgressBar2.max_value = MAX_COMPLETED_QUEUE
		Side.TEAM_ENEMY:
			$Sprite/ProgressBar.rect_position = HITPOINTS_BAR_POS_ENEMY
			$Sprite/TextureButton.queue_free()
			$Sprite/ProgressBar2.queue_free()

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

	var mech = MECH.instance()
	mech.side = side
	mech.initialize(order.blueprint, order.weapon_id, order.perk_id)

	order = null
	production_queue.pop_front()

	if side == Side.TEAM_PLAYER:
		Signals.emit_signal("on_order_completed", production_queue.size())

	if production_halted && completed_queue.size() < MAX_COMPLETED_QUEUE:
		completed_queue.append(mech)
		$Sprite/ProgressBar2.value += 1
		return

	emit_signal("on_mech_spawned", mech)

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

func _on_TextureButton_toggled(button_pressed: bool) -> void:
	production_halted = button_pressed

	if !production_halted:
		$TimerReleaseUnits.start(unit_release_delay)
	else:
		$TimerReleaseUnits.stop()


func _on_TimerReleaseUnits_timeout() -> void:
	if completed_queue.empty():
		$TimerReleaseUnits.stop()
		return

	var mech = completed_queue.pop_front()

	if mech != null:
		$Sprite/ProgressBar2.value -= 1
		emit_signal("on_mech_spawned", mech)
