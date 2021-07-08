extends RigidBody2D

const MAX_DECAY_TIME := 3.5

var decay_time := 0.0
var collected := false
var dir : Vector2
var _initial_speed : Vector2

func _ready() -> void:
	decay_time = MAX_DECAY_TIME
	_initial_speed = dir * 50
	linear_velocity = dir.rotated(deg2rad(randi()%360)) * 50

func _process(delta: float) -> void:
	if collected || decay_time <= 0:
		return

#	if _initial_speed.length() > 0:
#		_initial_speed = _initial_speed.linear_interpolate(Vector2.ZERO, delta)
#		global_position = global_position.linear_interpolate(global_position + _initial_speed, delta)

	decay_time -= delta

	if decay_time <= 0:
		_explode()

	$Sprite.self_modulate.r += .007
	$Sprite.self_modulate.g -= .007
	$Sprite.self_modulate.b -= .007

func _on_PowerModule_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if collected:
		return

	if event is InputEventScreenDrag:
		_on_collected()

func _on_PowerModule_mouse_entered() -> void:
	if collected:
		return

	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		_on_collected()

func _explode() -> void:
	decay_time = 0
	$CPUParticles2D.emitting = true
	$Sprite.visible = false

	if $AudioStreamPlayer.playing:
		yield($AudioStreamPlayer,"finished")
	else:
		yield(get_tree().create_timer(.25),"timeout")

	queue_free()

func _on_collected() -> void:
	collected = true
	$AudioStreamPlayer.play()
	Signals.emit_signal("on_PowerModule_collected")
	_explode()
