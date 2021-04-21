extends YSort


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _on_BasePlayer_on_mech_spawned(node) -> void:
	add_child(node)

func _on_BaseEnemy_on_mech_spawned(node) -> void:
	add_child(node)
