extends YSort

signal on_mech_spawned(mech)

const PowerModule := preload("res://scenes/PowerModule/PowerModule.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_BasePlayer_on_mech_spawned(node : Mech) -> void:
	node.destination = $BaseEnemy.global_position
	emit_signal("on_mech_spawned", node)
	add_child(node)

func _on_BaseEnemy_on_mech_spawned(node : Mech) -> void:
	node.destination = $BasePlayer.global_position
	node.connect("on_mech_die", self, "_on_mech_die")
	emit_signal("on_mech_spawned", node)
	add_child(node)

func _on_mech_die(pos : Vector2) -> void:
	var pmod : Node2D = PowerModule.instance()
	pmod.global_position = pos
	add_child(pmod)
