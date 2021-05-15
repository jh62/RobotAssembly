extends Area2D
class_name Mech

signal on_mech_die(position)
signal on_critical_hit

onready var health_bar := $ProgressBar
onready var lookeahed : float = $CollisionShape2D.shape.radius
onready var fire_tracer := $Line2D # provisorio
onready var timer_attack := $TimerAttack

export(Side.Team) var side setget set_side
export(Upgrades.Weapon) var weapon
export(Upgrades.Perk) var perk
export(Upgrades.Weapon) var weakness setget ,get_weakness

var max_hitpoints : float setget set_max_hitpoints
var hitpoints : float setget set_hitpoints
var speed : float
var damage : float
var fire_rate : float
var crit_chance : float setget set_crit_chance

var _target : Node2D

var tilemap : TileMap
var _path : PoolVector2Array
var _path_idx := 0
var destination : Vector2

var _initialized := false

func _ready() -> void:
	add_to_group(Groups.GROUP_MECH)
	get_new_path()
	health_bar.max_value = max_hitpoints
	timer_attack.start(fire_rate)

	match side:
		Side.TEAM_PLAYER:
			$Sprite.material = preload("res://scenes/Mech/player_side.tres")


func initialize(model_blueprint : Dictionary, module_weapon : int, module_perk : int) -> void:
	assert(model_blueprint != null)

	max_hitpoints = model_blueprint.get(Robots.Property.HITPOINTS)
	hitpoints = model_blueprint.get(Robots.Property.HITPOINTS)
	speed = model_blueprint.get(Robots.Property.SPEED)
#	damage = model_blueprint.get(Robots.Property.DAMAGE)
#	fire_rate = model_blueprint.get(Robots.Property.FIRE_RATE)
#	crit_chance = model_blueprint.get(Robots.Property.CRIT_CHANCE)
	weapon = model_blueprint.get(Robots.Property.WEAPON)
	perk = model_blueprint.get(Robots.Property.PERK)
	weakness = model_blueprint.get(Robots.Property.WEAKNESSES)

	if Upgrades.WeaponRef.has(module_weapon):
		weapon = module_weapon
		damage += Upgrades.WeaponRef[module_weapon][Upgrades.WeaponProperty.DAMAGE]
		fire_rate += Upgrades.WeaponRef[module_weapon][Upgrades.WeaponProperty.FIRE_RATE]
		crit_chance += Upgrades.WeaponRef[module_weapon][Upgrades.WeaponProperty.CRITICAL_CHANCE]

	if Upgrades.PerkRef.has(module_perk):
		perk = module_perk
		hitpoints += Upgrades.PerkRef[module_perk][Upgrades.PerkProperty.ARMOR]
		speed += Upgrades.PerkRef[module_perk][Upgrades.PerkProperty.SPEED]

	print_debug(damage)

	max_hitpoints = hitpoints

	_initialized = true

func _process(delta: float) -> void:
	if !_initialized:
		return

	health_bar.value = hitpoints

	if _target != null:
		if global_position.distance_to(_target.global_position) > lookeahed * 2 || _target.hitpoints <= 0.0:
			_target = null
		else:
			return

	move_toward_path(delta)

func on_attacked_by(attacker) -> void:
	var dam = attacker.damage if !weakness.has(attacker.weapon) else attacker.damage * 2.5

	if attacker.crit_chance > randf():
		dam *= 3
		emit_signal("on_critical_hit")

	hitpoints -= dam

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

	var w := tilemap.map_to_world(_path[_path_idx]) + Vector2(16,8)
	var dist := global_position.distance_to(w)

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

	if dist > 1:
		global_position = global_position.move_toward(w, delta * speed)
	else:
		var weight = tilemap.get_point_weight(global_position)
		tilemap.set_point_weight(w, weight - 1)
		_path_idx += 1

func get_weakness() -> float:
	return weakness[0]

func set_max_hitpoints(value : float) -> void:
	max_hitpoints = clamp(value, 0, value)

func set_hitpoints(value : float) -> void:
	hitpoints = clamp(value, 0, max_hitpoints)

func set_crit_chance(value) -> void:
	crit_chance = clamp(value, 0.0, 1.0)

func set_side(value : int) -> void:
	side = clamp(value, 0, Side.Team.size() - 1)

func _on_TimerAttack_timeout() -> void:
	if _target == null:
		return

	_target.on_attacked_by(self)

	fire_tracer.points[1] = global_position.direction_to(_target.global_position) * global_position.distance_to(_target.global_position)
	$Line2D/CPUParticles2D.emitting = true
	$Line2D/CPUParticles2D.global_position = _target.global_position

	yield(get_tree().create_timer(.25),"timeout")
	fire_tracer.points[1] = Vector2.ZERO
	$Line2D/CPUParticles2D.emitting = false

func _on_TimerScan_timeout() -> void:
	var areas := get_overlapping_areas()

	for t in areas:
		if t.side == side:
			continue

		var dist_to_target = global_position.distance_to(t.global_position)

		if _target == null || dist_to_target < global_position.distance_to(_target.global_position):
			_target = t
			if side == Side.TEAM_PLAYER:
				_target.modulate = Color.red
			break

func _on_MechVII_on_critical_hit() -> void:
	$Label.visible = true
	yield(get_tree().create_timer(1),"timeout")
	$Label.visible = false

# This is triggered when the players blocks/unblocks a passage tile.
func on_passage_toggle() -> void:
	pass
