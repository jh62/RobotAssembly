extends Panel

onready var label_amount := $MarginContainer/CenterContainer/VBoxContainer/HBoxContainerCosts/LabelAmount
onready var label_powermodules := $HBoxContainer/LabelPowerModules

func _ready() -> void:
	Signals.connect("on_PowerModule_collected", self, "_on_PowerModule_amount_changed")
	Signals.connect("on_PowerModule_consumed", self, "_on_PowerModule_amount_changed")
	Player.connect("on_funds_changed", self, "_on_funds_changed")
	_on_funds_changed()
	_on_PowerModule_amount_changed()

func _on_PowerModule_amount_changed() -> void:
	label_powermodules.text = str(Player.powermodules)

func _on_funds_changed() -> void:
	yield(get_tree(),"idle_frame")
	label_amount.text = "${funds}".format([Player.funds],"{funds}")


func _on_TextureButton_button_up() -> void:
	if Player.powermodules == 0:
		return

#	Player.powermodules = max(Player.powermodules - 1, 0)
	Signals.emit_signal("on_PowerModule_consumed")
	Player.funds += 100
