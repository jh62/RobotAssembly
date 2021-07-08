extends Area2D
class_name Mech

signal on_mech_die(this, credits_dropped)
signal on_critical_hit
signal on_hit

onready var health_bar := $VBoxContainer/ProgressBar
onready var lookeahed : float = $CollisionShape2D.shape.radius
onready var timer_attack := $TimerAttack

export(Side.Team) var side setget set_side
export(Upgrade.Weapon) var weapon
export(Upgrade.Perk) var perk
export(Upgrade.Weapon) var weakness setget ,get_weakness

var max_hitpoints : float setget set_max_hitpoints
var hitpoints : float setget set_hitpoints
var speed : float
var damage : float
var fire_rate : float
var crit_chance : float setget set_crit_chance

var _target : Node2D
var _facing : Vector2

var tilemap : TileMap
var _path : PoolVector2Array
var _path_idx := 0
var destination : Vector2

var _initialized := false

func _ready() -> void:
	Signals.connect("toggle_view_upgrades", self, "_on_toggle_view_upgrades")
	add_to_group(Groups.GROUP_MECH)
	get_new_path()
	health_bar.max_value = max_hitpoints
	timer_attack.start(fire_rate)

	$Sprite.offset = Vector2(randi()%24+8,randi()%24+8)
	$Sprite2.offset = $Sprite.offset
	$Sprite2.scale = $Sprite.scale
	z_index = $Sprite.offset.y

	match side:
		Side.TEAM_ENEMY:
			$Sprite.material = preload("res://scenes/Mech/player_side.tres")

	_find_targets()

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

	if Upgrade.WeaponRef.has(module_weapon):
		weapon = module_weapon
		damage += Upgrade.WeaponRef[module_weapon][Upgrade.WeaponProperty.DAMAGE]
		fire_rate += Upgrade.WeaponRef[module_weapon][Upgrade.WeaponProperty.FIRE_RATE]
		crit_chance += Upgrade.WeaponRef[module_weapon][Upgrade.WeaponProperty.CRITICAL_CHANCE]

	if Upgrade.PerkRef.has(module_perk):
		perk = module_perk

		var downsides = Upgrade.PerkRef[module_perk].get(Upgrade.PerkProperty.DOWNSIDES)

		if downsides && downsides.size() >= 1:
			damage += downsides.get(Upgrade.WeaponProperty.DAMAGE)
			fire_rate += downsides.get(Upgrade.WeaponProperty.FIRE_RATE)
			crit_chance += downsides.get(Upgrade.WeaponProperty.CRITICAL_CHANCE)

		hitpoints += hitpoints * Upgrade.PerkRef[module_perk][Upgrade.PerkProperty.ARMOR]
		speed += speed * Upgrade.PerkRef[module_perk][Upgrade.PerkProperty.SPEED]

	max_hitpoints = hitpoints


	var icon_weapon := $VBoxContainer/UpgradeIcons/WeaponUpgrade
	var icon_perk := $VBoxContainer/UpgradeIcons/PerkUpgrade

	if weapon >= 0:
		icon_weapon.texture = Upgrade.WeaponRef[weapon][Upgrade.WeaponProperty.ICON]

	if perk >= 0:
		icon_perk.texture = Upgrade.PerkRef[perk][Upgrade.PerkProperty.ICON]

	icon_weapon.visible = weapon >= 0
	icon_perk.visible = perk >= 0

	$VBoxContainer.visible = Player.upgrades_visible

	_initialized = true

func _process(delta: float) -> void:
	if !_initialized:
		return
	if hitpoints <= 0:
		if modulate.a > 0:
			modulate.a -= delta
		else:
			queue_free()
		return

	health_bar.value = hitpoints

	if _target != null:
		if global_position.distance_to(_target.global_position) > lookeahed * 2 || _target.hitpoints <= 0.0:
			_target = null
			_find_targets()
		return

	move_toward_path(delta)

func on_attacked_by(attacker) -> void:
	if hitpoints <= 0:
		return

	var dam = attacker.damage if !weakness.has(attacker.weapon) else attacker.damage * 2.5

	if attacker.crit_chance > randf():
		dam *= 2
		emit_signal("on_critical_hit")

	hitpoints -= dam

	if hitpoints <= 0:
		var drop = Upgrade.get_weapon_cost(weapon) + Upgrade.get_perk_cost(perk)
		emit_signal("on_mech_die", self, drop)
		_add_weight(_path, -1)
		$AnimationPlayer.play("explode" + get_anim_facing())
		SoundManager.play_sfx("robot_explode")
	else:
		emit_signal("on_hit")

func get_new_path() -> void:
	_path = tilemap.get_waypoints(global_position, destination, side)
	_path_idx = 0

	_add_weight(_path)

func _add_weight(path_points : PoolVector2Array, amount := 1) -> void:
	if !path_points:
		return

	for p in path_points:
		var weight = tilemap.astar.get_point_weight_scale(tilemap.id(p))
		tilemap.astar.set_point_weight_scale(tilemap.id(p), weight + amount)

func get_direction(to : Vector2) -> Vector2:
	return global_position.direction_to(to).round()

func get_anim_facing() -> String:
	var anim : String

	match _facing:
		Vector2(0,-1):
			anim += "_n"
		Vector2(0,1):
			anim += "_s"
		Vector2(1,0):
			anim += "_e"
		Vector2(-1,0):
			anim += "_w"
		Vector2(1,-1):
			anim += "_ne"
		Vector2(1,1):
			anim += "_se"
		Vector2(-1,1):
			anim += "_sw"
		Vector2(-1,-1):
			anim += "_nw"

	return anim

func move_toward_path(delta : float) -> void:
	if _path.empty() || _path_idx >= _path.size():
		return

	var w := tilemap.map_to_world(_path[_path_idx])
	var dist := global_position.distance_to(w)

	var anim : String

	if dist > 1:
		anim = "move"
	else:
		anim = "idle"

	_facing = get_direction(w)
	anim += get_anim_facing()
	$AnimationPlayer.play(anim)

	if dist > 2:
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
	if hitpoints <= 0:
		$TimerAttack.stop()
		return

	_facing = get_direction(_target.global_position)
	_target.on_attacked_by(self)
	$AnimationPlayer.play("shoot" + get_anim_facing())
	SoundManager.play_sfx("machine_gun", rand_range(0.9,1.1))

func play_fx(sfx_name : String) -> void:
	SoundManager.play_sfx(sfx_name)

func _on_TimerScan_timeout() -> void:
	if hitpoints <= 0:
		$TimerScan.stop()
		return

	_find_targets()

func _find_targets() -> void:
	var areas := get_overlapping_areas()

	for t in areas:
		if !("hitpoints" in t):
			continue
		if t.side == side:
			continue

		var dist_to_target = global_position.distance_to(t.global_position)

		if _target == null || dist_to_target < global_position.distance_to(_target.global_position):
			_target = t
			break

func _on_MechVII_on_critical_hit() -> void:
	$Label.visible = true
	yield(get_tree().create_timer(1),"timeout")
	$Label.visible = false

# This is triggered when the players blocks/unblocks a passage tile.
func on_passage_toggle() -> void:
	pass

func _on_toggle_view_upgrades() -> void:
	if has_node("VBoxContainer"):
		$VBoxContainer.visible = Player.upgrades_visible

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("explode"):
		set_process(false)
		set_physics_process(false)
		$CollisionShape2D.queue_free()
		$VBoxContainer.queue_free()
		$Label.visible = false

func _on_MechVII_on_hit() -> void:
	$Sprite2.visible = true
	$AnimationPlayer2.play("hit" + get_anim_facing())
	yield(get_tree().create_timer(.3),"timeout")
	$Sprite2.visible = false
