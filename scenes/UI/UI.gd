extends CanvasLayer

func _ready() -> void:
	pass

func _on_ButtonToggleUpgradesView_button_up() -> void:
	Player.upgrades_visible = !Player.upgrades_visible
	Signals.emit_signal("toggle_view_upgrades")
