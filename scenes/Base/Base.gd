extends Area2D
class_name Base

signal on_mech_spawned(node)

const MECH := preload("res://scenes/Mech/Mech.tscn")

export var is_active := true setget set_active
export var production_rate := 5.0
export var side := Side.PLAYER
export var path_node : NodePath

var _spawn_point := Vector2.ZERO
var _path : PathFollow2D

func _ready() -> void:
	assert(path_node != null)
	set_active(is_active)

func _process(delta: float) -> void:
	pass

func get_random_path() -> PathFollow2D:
	var paths := get_node(path_node)
	var p := paths.get_child(randi()%paths.get_child_count())
	return p.get_child(0) as PathFollow2D

func get_spawn_point(path : PathFollow2D) -> Vector2:
	if side == Side.PLAYER:
		path.unit_offset = 0.0
	else:
		path.unit_offset = 1.0

	return path.global_position

func set_active(active : bool) -> void:
	is_active = active

	if is_active:
		$Timer_Production.start(production_rate)
	else:
		$Timer_Production.stop()

func _on_Timer_Production_timeout() -> void:
	if !is_active:
		$Timer_Production.stop()
		return

	var path = get_random_path()

	var mech := MECH.instance()
	mech.side = side
	mech.global_position = get_spawn_point(path)
	mech._path_follow = path
	emit_signal("on_mech_spawned", mech)
