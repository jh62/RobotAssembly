extends Node

signal on_mech_spawned(mech)

const PowerModule := preload("res://scenes/PowerModule/PowerModule.tscn")

onready var mobiles := $Mobiles
onready var statics := $Statics

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_BasePlayer_on_mech_spawned(node) -> void:
	emit_signal("on_mech_spawned", node)
	mobiles.add_child(node)

func _on_BaseEnemy_on_mech_spawned(node) -> void:
	node.connect("on_mech_die", self, "_on_mech_die")
	emit_signal("on_mech_spawned", node)
	mobiles.add_child(node)

func _on_mech_die(entity : Node2D, amount : int) -> void:
	var pmod : Node2D = PowerModule.instance()
	pmod.global_position = entity.global_position
	pmod.dir = entity._facing.rotated(deg2rad(45))
	mobiles.remove_child(entity)

	statics.add_child(pmod)
	statics.add_child(entity)

func _on_BasePlayer_on_passage_toggle(cellv, blocked) -> void:
	for e in get_tree().get_nodes_in_group(Groups.GROUP_MECH):
		if e.side == Side.Team.PLAYER:
			e.on_passage_toggle()


func _on_Entities_on_mech_spawned(mech) -> void:
	pass # Replace with function body.
