extends Area2D

var start_pos : Vector2
var end_pos : Vector2
var xx := 0.0

var collected := false
var decay := 0.0

func _ready() -> void:
	start_pos = global_position
	var r := randi()%100
	end_pos = start_pos + Vector2(r * sin(r), -20 + randi()%40)
	end_pos.x = clamp(end_pos.x, 320, 320 + 288)
	end_pos.y = clamp(end_pos.y, 153, 153 + 272)
	$Tween.stop_all()
	$Tween.interpolate_property($Sprite,"scale", Vector2(.75,1.5), Vector2(1.0,1.0), .14)
	$Tween.start()

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.linear_interpolate(p1, t)
	var q1 = p1.linear_interpolate(p2, t)
	var r = q0.linear_interpolate(q1, t)
	return r

func _process(delta: float) -> void:
	if !collected:
		global_position = _quadratic_bezier(start_pos, (start_pos + end_pos) / 2 + Vector2(0,-50), end_pos, xx)
		xx = clamp(xx + delta, 0.0, 1.0)
	elif decay < .25:
		decay += delta
	else:
		queue_free()

func _on_PowerModule_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenDrag:
		$CPUParticles2D.emitting = true
		collected = true
		$Sprite.visible = false
		Signals.emit_signal("on_PowerModule_collected", randi()%100)


func _on_PowerModule_mouse_entered() -> void:
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		$CPUParticles2D.emitting = true
		collected = true
		$Sprite.visible = false
		Signals.emit_signal("on_PowerModule_collected", randi()%100)


