extends "res://scenes/Base/Base.gd"

onready var base_ai

func _ready() -> void:
	var BaseAI := preload("res://autoload/BaseAI.gd")
	base_ai = BaseAI.new(self)
	base_ai.penalty_time = 2.0

	for i in 1000:
		base_ai.spawn_list.append(Robots.ROBOT_A1)

	add_child(base_ai)

func _process(delta: float) -> void:
	if !is_active:
		return

	if base_ai.penalty_time > 0:
		modulate = Color.red
	else:
		modulate = Color.white

	base_ai.process(delta)

func _on_rushpoint_destroyed() -> void:
	base_ai.penalty_time += 18.0
