tool
extends RayCast2D

var side := Side.PLAYER

func _ready() -> void:
	$Line2D.points[1] = Vector2.ZERO

func _process(delta: float) -> void:
	pass

func shoot_at(pos : Vector2) -> void:
	if $Tween.is_active():
		return
#
	cast_to = global_position.direction_to(pos) * global_position.distance_to(pos)
	force_raycast_update()
	$Line2D.points[1] = cast_to
#
#	if is_colliding():
#		var collider := get_collider()
#		if collider.side == side:
#			return
#		collider.on_attacked_by(owner)

	appear()

func appear() -> void:
	var color := Color.rebeccapurple if side == Side.PLAYER else Color.red
	modulate = color
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"modulate", color, Color.transparent, 0.25)
	$Tween.start()
