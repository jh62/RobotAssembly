extends TileMap

signal on_passage_toggle(cellv, blocked)

const PASSAGE_TILES_ID := [3,4]

var passage_tiles := {}

func _ready() -> void:
#	assert(get_used_cells_by_id(3).size() == 1, "Only one passage can be opened at a time!")
	yield(get_tree(),"idle_frame")

	for t in get_used_cells():
		var cell := get_cellv(t)
		if cell in PASSAGE_TILES_ID:
			var disabled := cell == 4
			passage_tiles[t] = disabled
			emit_signal("on_passage_toggle", t, disabled)

func _unhandled_input(event: InputEvent) -> void:
	if passage_tiles.size() == 0:
		return

	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if !event.pressed && event.button_index == BUTTON_LEFT:
			var cellv := world_to_map(event.position)
			var cell := get_cellv(cellv)

			if !(cell in PASSAGE_TILES_ID):
				return

			for c in passage_tiles:
				var is_selected = c == cellv
				passage_tiles[c] = !is_selected
				set_cellv(c, 3 if is_selected else 4)
				emit_signal("on_passage_toggle", c, !is_selected)
