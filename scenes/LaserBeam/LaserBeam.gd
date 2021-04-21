tool
extends RayCast2D

func _ready() -> void:
	$Line2D.points[1] = Vector2.ZERO

func _process(delta: float) -> void:
	pass

func shoot_at(pos : Vector2) -> void:
	if $Tween.is_active():
		return

	cast_to = global_position.direction_to(pos) * global_position.distance_to(pos)
	force_raycast_update()
	$Line2D.points[1] = cast_to

	if is_colliding():
		get_collider().hurt()

	appear()

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width", 0.0, 2.0, 0.2)
	$Tween.start()

func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D,"width", 2.0, 0, .01)
	$Tween.start()
