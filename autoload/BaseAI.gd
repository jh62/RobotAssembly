extends Node
class_name BaseAI

var build_wait_time := 1.0
var penalty_time := 0.0
var last_build_time := 0.0

var spawn_list := []
var base : Node
var funds := 500 setget set_funds

func _init(b) -> void:
	self.base = b

func _ready() -> void:
#	Signals.connect("on_build_begin", self, "_on_player_build_begin")
	spawn_list.shuffle()

func _on_player_build_begin(amount = 1, total_time = 0.0) -> void:
	if !base.is_active:
		return

	if spawn_list.empty():
		return

	if penalty_time > 0.0:
		return

	for i in amount:
		var robot = spawn_list.pop_back()

		if robot == null:
			break

		var cost_estimate =	Upgrade.get_weapon_cost(robot.get(Robots.Property.WEAPON)) + Upgrade.get_perk_cost(robot.get(Robots.Property.PERK))

		if cost_estimate > funds:
			print_debug("I don't have enough funds!")
			return
		else:
			self.funds -= cost_estimate

		print_debug(funds)

		var time_estimate = robot.get(Robots.Property.PRODUCTION_TIME)
		base._on_build_requested(robot, 1, -1, -1, time_estimate * 1)

	last_build_time = 0.0

func process(delta) -> void:
	if spawn_list.empty():
		return

	if penalty_time > 0:
		penalty_time = max(0.0, penalty_time - delta)
		return

	last_build_time += delta

	if last_build_time >= build_wait_time:
		last_build_time = 0.0
		_on_player_build_begin()

func set_funds(new_value) -> void:
	funds = clamp(new_value, 0, 999999)
