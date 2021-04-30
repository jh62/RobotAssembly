extends Panel

onready var label_amount := $MarginContainer/CenterContainer/VBoxContainer/HBoxContainerCosts/LabelAmount

func _ready() -> void:
	Signals.connect("on_PowerModule_collected", self, "_on_PowerModule_collected")

func _on_PowerModule_collected(amount : int) -> void:
	yield(get_tree(),"idle_frame")
	label_amount.text = "${funds}".format([Player.funds],"{funds}")
