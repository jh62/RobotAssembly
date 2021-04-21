extends Area2D
class_name Mech

const LASER_BEAM := preload("res://scenes/LaserBeam/LaserBeam.tscn")
const TEXTURE_ENEMY := preload("res://scenes/Mech/MechEnemyTexture.tres")
const TEXTURE_PLAYER := preload("res://scenes/Mech/MechPlayerTexture.tres")

const TARGET_SCAN_DELAY_SECONDS := 2.0

export var lookeahed := 25
export var side := Side.PLAYER

onready var health_bar := $ProgressBar

var hitpoints := 10.0
var speed := .1
var damage := .5
var fire_rate := 1.0
var crit_chance := .1

var weapons := []
var perks := []

var _target : Node2D
var _target_scan_time := 0.0

var _path_follow : PathFollow2D
var _path_offset := 0.0
var _path_dir := 1

func _ready() -> void:
	health_bar.max_value = hitpoints
	health_bar.value = hitpoints

	match side:
		Side.PLAYER:
			_path_dir = 1
			$Sprite.texture = TEXTURE_PLAYER
		Side.ENEMY:
			_path_dir = -1
			$Sprite.texture = TEXTURE_ENEMY

	_path_follow.unit_offset = 1.0 if side == Side.PLAYER else 0.0
	global_position = _path_follow.global_position

func _process(delta: float) -> void:
	health_bar.value = hitpoints

	if _target_scan_time > TARGET_SCAN_DELAY_SECONDS:
		_target_scan_time = 0

		var targets := get_overlapping_areas()

		for t in targets:
			if t.side == side:
				continue

			var d : float = t.global_position.distance_to(global_position)
			if _target == null || d < _target.global_position.distance_to(global_position):
				_target = t
				break
	else:
		_target_scan_time += delta

	if _target != null:
		$LaserBeam.shoot_at(_target.global_position)
		return

	var next_step := get_next_step(delta)
	$RayCast2D.cast_to = global_position.direction_to(next_step).round() * lookeahed

	if $RayCast2D.is_colliding():
		var m := $RayCast2D.get_collider() as Mech
		if m == null || m.hitpoints <= 0:
			_target = null
		elif m.side != side:
			_target = m

	move_along_path(delta)

func hurt() -> void:
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()

func move_along_path(delta) -> void:
	_path_offset += speed * _path_dir * delta
	_path_offset = wrapf(_path_offset, 0.0, 1.0)
	_path_follow.unit_offset = _path_offset
	global_position =_path_follow.global_position

func get_next_step(delta : float) -> Vector2:
	var offset := _path_offset + speed * delta * _path_dir
	_path_follow.unit_offset = offset
	var new_pos := _path_follow.global_position
	return new_pos

func _on_Timer_timeout() -> void:
	if _target == null:
		return
	$LaserBeam.shoot_at(_target.global_position)

func _on_Mech_area_entered(area: Area2D) -> void:
	if area.side == side:
		return
	if _target == null || area.global_position.distance_to(global_position) < _target.global_position.distance_to(global_position):
		_target = area
		return
