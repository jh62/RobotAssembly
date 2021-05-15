extends TileMap

signal on_passage_toggle(cellv, blocked)

var passage_tiles := {}

func _ready() -> void:
	for t in get_used_cells_by_id(3):
		passage_tiles[t] = false

func _unhandled_input(event: InputEvent) -> void:
	if passage_tiles.size() == 0:
		return

	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if !event.pressed && event.button_index == BUTTON_LEFT:
			var cellv := world_to_map(event.position)

			if get_cellv(cellv) == -1 ||  get_cellv(cellv) == 3 && get_used_cells_by_id(3).size() <= 1 && get_cellv(cellv) != 4:
				return

			passage_tiles[cellv] = !passage_tiles[cellv]
			set_cellv(cellv, 4 if passage_tiles[cellv] else 3)
			emit_signal("on_passage_toggle", cellv, passage_tiles[cellv])
