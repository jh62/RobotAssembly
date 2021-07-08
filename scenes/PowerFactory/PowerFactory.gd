extends Area2D

const POWER_MODULE_DURATION := 30.0

var side = Side.Team.ENEMY
var module_consumed := POWER_MODULE_DURATION
var power_modules := 0


func _ready() -> void:
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.frame = 0

func _process(delta: float) -> void:
	var player_units := 0
	var enemy_units := 0

	for a in get_overlapping_areas():
		if a.side == Side.Team.ENEMY:
			enemy_units += 1
		else:
			player_units += 1

	if player_units == 0 && enemy_units >= 1:
		$PanelContainer/VBoxContainer/ProgressBar.value -=  clamp(delta * enemy_units, .05, .25)
	elif player_units >= 1 && enemy_units == 0:
		$PanelContainer/VBoxContainer/ProgressBar.value += clamp(delta * player_units, .01, .25)

	if $PanelContainer/VBoxContainer/ProgressBar.value >= $PanelContainer/VBoxContainer/ProgressBar.max_value:
		side = Side.Team.PLAYER
		$PanelContainer/VBoxContainer/HBoxContainer/Label.text  = "PLAYER"
	elif $PanelContainer/VBoxContainer/ProgressBar.value == 0:
		side = Side.Team.ENEMY
		$PanelContainer/VBoxContainer/HBoxContainer/Label.text = "ENEMY"

	if power_modules >= 1:
		if $AnimatedSprite.animation != "powered":
			$AnimatedSprite.play("powered")

		module_consumed -= delta
		if module_consumed < 0.0:
			module_consumed = POWER_MODULE_DURATION
			power_modules = max(power_modules - 1, 0)
	else:
		if $AnimatedSprite.animation != "idle":
			$AnimatedSprite.play("idle")
			$Timer.stop()

	$AnimatedSprite2.frame = clamp(power_modules, 0, 3)

func _on_TextureButton_button_up() -> void:
	if side != Side.Team.PLAYER:
		return
	if Player.powermodules == 0:
		return
	if power_modules >= 3:
		return

	Player.powermodules -= 1
	power_modules += 1
	$Timer.start()
	Signals.emit_signal("on_PowerModule_consumed")


func _on_Timer_timeout() -> void:
	if power_modules == 0:
		$Timer.stop()
		return

	var amount := 3.48 * power_modules

	if  side == Side.Team.PLAYER:
		Player.funds += amount
	else:
		Signals.emit_signal("on_enemy_funds_increase", amount)
