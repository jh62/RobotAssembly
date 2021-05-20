extends Area2D

export var hitpoints := 50.0 setget set_hitpoints

var alive := true
var side := Side.TEAM_ENEMY

signal on_rushpoint_destroyed

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !alive:
		return

	if hitpoints == 0.0:
		alive = false
		$CollisionShape2D.disabled = true
		emit_signal("on_rushpoint_destroyed")

func on_attacked_by(attacker : Node2D) -> void:
	self.hitpoints -= attacker.damage

func set_hitpoints(new_value) -> void:
	hitpoints = max(0.0, new_value)
