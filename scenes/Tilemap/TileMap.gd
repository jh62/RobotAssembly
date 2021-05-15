extends TileMap

onready var astar := AStar2D.new()

func _ready() -> void:
	_add_points()
	_connect_points()

func _add_points() -> void:
	for cell in get_used_cells():
		if get_cellv(cell) == 1:
			astar.add_point(id(cell),cell, 1.0)

func _connect_points() -> void:
	var used_cells := get_used_cells()

	for cell in used_cells:
		var neighbors : PoolVector2Array = [Vector2.UP, Vector2.LEFT, Vector2.RIGHT, Vector2.DOWN]
		for n in neighbors:
			var next = cell + n
			if used_cells.has(next):
				astar.connect_points(id(cell),id(next), true)

func get_waypoints(from : Vector2, to : Vector2) -> PoolVector2Array:
	from = world_to_map(from)
	to = world_to_map(to)
	var p = astar.get_point_path(id(from),id(to))
	p.remove(0)

	return p

func set_point_weight(pos : Vector2, weight : float) -> void:
	pos = world_to_map(pos)
	astar.set_point_weight_scale(id(pos),max(0, weight))

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

	mech.global_position = map_to_world(spawn_points[randi()%spawn_points.size()]) + Vector2(16,16)
	mech.destination = map_to_world(dest_points[dest_points.size()-1]) + Vector2(16,16)
	mech.tilemap = self


func _on_BasePlayer_on_passage_toggle(cellv, blocked) -> void:
	astar.set_point_disabled(id(cellv), blocked)
	print_debug(blocked)
