extends Area2D
class_name Mech

signal on_mech_die(position)

const LASER_BEAM := preload("res://scenes/LaserBeam/LaserBeam.tscn")
const TEXTURE := preload("res://scenes/Mech/MechPlayerTexture.tres")

const TARGET_SCAN_DELAY_SECONDS := 2.0

export var side := Side.PLAYER

onready var health_bar := $ProgressBar
onready var lookeahed : float = $CollisionShape2D.shape.radius * 2

var hitpoints := 20.0
var speed := 20
var damage := .5
var fire_rate := 1.0
var crit_chance := .1

var weapons := []
var perks := []

var _target : Node2D

var tilemap : TileMap
var _path : PoolVector2Array
var _path_idx := 0
var destination : Vector2

func _ready() -> void:
	add_to_group(Groups.GROUP_MECH)
	health_bar.max_value = hitpoints
	health_bar.value = hitpoints
	$LaserBeam.side = side

	match side:
		Side.PLAYER:
			$Sprite.material = preload("res://scenes/Mech/player_side.tres")

	get_new_path()

	for w in weapons:
		if w != -1:
			damage += Upgrades.WeaponRef[w][Upgrades.WeaponProperty.DAMAGE]

	for p in perks:
		if p != -1:
			speed += Upgrades.PerkRef[p][Upgrades.PerkProperty.SPEED]

func _process(delta: float) -> void:
	health_bar.value = hitpoints

	if _target != null:
		if _target.global_position.distance_to(global_position) > lookeahed || _target.hitpoints <= 0:
			_target = null
		else:
			return

	move_toward_path(delta)

#func get_damage() -> float:
#	var d := damage
#	for w in weapons:
#		if w == -1:
#			continue
#		d += Upgrades.WeaponRef[w][Upgrades.WeaponProperty.DAMAGE]
#	return d

func on_attacked_by(attacker) -> void:
	hitpoints -= attacker.damage
	if hitpoints <= 0:
		emit_signal("on_mech_die", global_position)
		queue_free()

func get_new_path() -> void:
	_path = tilemap.get_waypoints(global_position, destination)
	_path_idx = 0

	for p in _path:
		var weight = tilemap.astar.get_point_weight_scale(tilemap.id(p))
		tilemap.astar.set_point_weight_scale(tilemap.id(p), weight + 1)

func move_toward_path(delta : float) -> void:
	if _path.empty() || _path_idx >= _path.size():
		return

	var w := tilemap.map_to_world(_path[_path_idx])
	var dist := global_position.distance_to(w)

	if dist > 1:
		global_position = global_position.move_toward(w, delta * speed)
		var look_at := global_position.direction_to(w).round()

		match look_at:
			Vector2(0,-1):
				$AnimationPlayer.play("idle_n")
			Vector2(0,1):
				$AnimationPlayer.play("idle_s")
			Vector2(1,0):
				$AnimationPlayer.play("idle_e")
			Vector2(-1,0):
				$AnimationPlayer.play("idle_w")
			Vector2(1,-1):
				$AnimationPlayer.play("idle_ne")
			Vector2(1,1):
				$AnimationPlayer.play("idle_se")
			Vector2(-1,1):
				$AnimationPlayer.play("idle_sw")
			Vector2(-1,-1):
				$AnimationPlayer.play("idle_nw")
	else:
		var weight = tilemap.get_point_weight(global_position)
		tilemap.set_point_weight(w, weight - 1)
		_path_idx += 1

func _on_Timer_timeout() -> void:
	if _target == null:
		return

	$LaserBeam.shoot_at(_target.global_position)
	_target.on_attacked_by(self)

func _on_Mech_area_entered(area: Area2D) -> void:
	if area.side == side:
		return
	if _target == null || area.global_position.distance_to(global_position) < _target.global_position.distance_to(global_position):
		_target = area
		return

func _on_TimerScan_timeout() -> void:
	var areas := get_overlapping_areas()

	for t in areas:
		if t.side == side:
			continue

		var d : float = t.global_position.distance_to(global_position)
		if _target == null || t.is_in_group(Groups.GROUP_BASE) || d < _target.global_position.distance_to(global_position):
			_target = t
			break
