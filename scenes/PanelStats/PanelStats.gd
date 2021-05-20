extends Panel

onready var label_amount := $MarginContainer/CenterContainer/VBoxContainer/HBoxContainerCosts/LabelAmount

func _ready() -> void:
	Signals.connect("on_PowerModule_collected", self, "_on_PowerModule_collected")
	Player.connect("on_funds_changed", self, "_on_funds_changed")

func _on_funds_changed() -> void:
	yield(get_tree(),"idle_frame")
	label_amount.text = "${funds}".format([Player.funds],"{funds}")
