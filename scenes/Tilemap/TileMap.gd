extends TileMap

onready var astar := AStar2D.new()
onready var astar_enemy := AStar2D.new()

var disabled_points := {}

func _ready() -> void:
	_add_points(astar)
	_connect_points(astar)
	_add_points(astar_enemy)
	_connect_points(astar_enemy)

func _add_points(astar : AStar2D, allowed := {26:9999.0}, default_weight := 1.0) -> void:
	for cell in get_used_cells():
		var cell_id := get_cellv(cell)
		var weight = allowed.get(cell_id, default_weight)
		astar.add_point(id(cell),cell, weight)

func _connect_points(astar : AStar2D) -> void:
	var used_cells := get_used_cells()

	for cell in used_cells:
		var neighbors : PoolVector2Array = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
		for n in neighbors:
			var next = cell + n
			if used_cells.has(next):
				astar.connect_points(id(cell),id(next), true)

func get_waypoints(from : Vector2, to : Vector2, side : int) -> PoolVector2Array:
	from = world_to_map(from)
	to = world_to_map(to)

	var path

	match side:
		Side.Team.PLAYER:
			path = astar.get_point_path(id(from),id(to))
		_:
#			var disabled
#			for point in disabled_points:
#				if !disabled && !astar_enemy.is_point_disabled(point) && randf() > .5:
#					astar_enemy.set_point_disabled(point, true)
#					disabled = true
#				else:
#					astar_enemy.set_point_disabled(point, false)

			path = astar_enemy.get_point_path(id(from),id(to))

#	path.remove(0)

	return path

func set_point_weight(pos : Vector2, weight : float) -> void:
	pos = world_to_map(pos)
	astar.set_point_weight_scale(id(pos),max(0, weight))
	astar_enemy.set_point_weight_scale(id(pos),max(0, weight))

func get_point_weight(pos : Vector2) -> float:
	return astar.get_point_weight_scale(id(world_to_map(pos)))

func id(point : Vector2) -> float:
	var a := point.x
	var b := point.y
	return (a + b) * (a + b + 1) / 2 + b

func _on_Entities_on_mech_spawned(mech) -> void:
	var spawn_points : PoolVector2Array
	var dest_points : PoolVector2Array

	match mech.side:
		Side.TEAM_PLAYER:
			spawn_points = $BasePlayer.get_used_cells_by_id(2)
			dest_points = $BaseEnemy.get_used_cells_by_id(2)
		Side.TEAM_ENEMY:
			spawn_points = $BaseEnemy.get_used_cells_by_id(2)
			dest_points = $BasePlayer.get_used_cells_by_id(2)

	mech.global_position = map_to_world(spawn_points[randi()%spawn_points.size()])
	mech.destination = map_to_world(dest_points[dest_points.size()-1])
	mech.tilemap = self

func _on_BasePlayer_on_passage_toggle(cellv, disabled) -> void:
	var point := id(cellv)
	astar.set_point_disabled(point, disabled)

	if !disabled_points.has(point):
		disabled_points[point] = disabled
