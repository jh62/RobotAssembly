extends Node2D

var from : Vector2
var to : Vector2

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton

		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				pass
			elif event.button_index == BUTTON_RIGHT:
				to = get_global_mouse_position()
		else:
			if to != Vector2.ZERO:
#				$Sprite/Line2D.points[0] = $Sprite.global_position
				$Sprite/Line2D.points[1] = $Sprite.global_position.direction_to(to) * $Sprite.global_position.distance_to(to)
