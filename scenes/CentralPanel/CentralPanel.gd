extends Panel

onready var label_quantity := $MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Panel/Label

var production_quantity := 10 setget set_quantity

func _ready() -> void:
	label_quantity.text = str(production_quantity)

func set_quantity(amount : int) -> void:
	production_quantity = clamp(amount, 0, 10)
	label_quantity.text = str(production_quantity)

func _on_Button_button_up() -> void:
	set_quantity(production_quantity - 1)
	Signals.emit_signal("on_quantity_changed", production_quantity)


func _on_Button2_button_up() -> void:
	set_quantity(production_quantity + 1)
	Signals.emit_signal("on_quantity_changed", production_quantity)
