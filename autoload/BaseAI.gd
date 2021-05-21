extends Node

var build_wait_time := 3.0
var penalty_time := 0.0
var last_build_time := 0.0

var spawn_list := []
var base : Node

func _init(b) -> void:
	self.base = b

func _ready() -> void:
	Signals.connect("on_build_begin", self, "_on_player_build_begin")
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

		var time_estimate = robot.get(Robots.Property.PRODUCTION_TIME)
		base._on_build_requested(robot, 1, -1, -1, time_estimate * 1)

	last_build_time = 0.0

func process(delta) -> void:
	if spawn_list.empty():
		return

	if penalty_time > 0:
		penalty_time = max(penalty_time - delta, 0.0)
		print_debug(penalty_time)
		return

	last_build_time += delta

	if last_build_time >= build_wait_time:
		_on_player_build_begin()
		last_build_time = 0.0
