extends Panel

onready var label_quantity := $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/Panel/Label
onready var label_cost := $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Panel/VBoxContainer/HBoxContainer/Label2
onready var label_time := $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/Panel/VBoxContainer/HBoxContainer2/Label2
onready var label_queue := $MarginContainer/VBoxContainer/Panel/HBoxContainerQueue/CenterContainer/Label
onready var progress_queue := $MarginContainer/VBoxContainer/Panel/HBoxContainerQueue/ProgressBar

var production_quantity := 1 setget set_quantity

func _ready() -> void:
	Signals.connect("on_upgrade_installed", self, "_on_upgrade_changed")
	Signals.connect("on_upgrade_removed", self, "_on_upgrade_changed")
	Signals.connect("on_build_begin", self, "_on_build_begin")
	Signals.connect("on_queue_step", self, "_on_queue_step")
	Signals.connect("on_order_completed", self, "_on_order_completed")
	label_quantity.text = str(production_quantity)
	label_queue.text = "0/%s" % Constants.MAX_PRODUCTION_QUEUE
	update_production_projections()

func set_quantity(amount : int) -> void:
	production_quantity = clamp(amount, 0, 10)
	label_quantity.text = str(production_quantity)

func _on_Button_button_up() -> void:
	set_quantity(production_quantity - 1)
	_on_upgrade_changed()
	Signals.emit_signal("on_quantity_changed", production_quantity)

func _on_Button2_button_up() -> void:
	set_quantity(production_quantity + 1)
	_on_upgrade_changed()
	Signals.emit_signal("on_quantity_changed", production_quantity)

func _on_upgrade_changed(upgrade_type = -1, upgrade_id = -1) -> void:
	yield(get_tree().create_timer(.01),"timeout")
	update_production_projections()

func _on_ButtonBuild_button_up() -> void:
	Signals.emit_signal("on_build_requested", Player.MECH, production_quantity, Player.active_weapon, Player.active_perk, float(label_time.text))

func _on_build_begin(amount : int, production_time : float) -> void:
	label_queue.text = "%s/%s" % [amount, Constants.MAX_PRODUCTION_QUEUE]
	progress_queue.max_value = production_time
	progress_queue.value = 0.0

func _on_queue_step(amount : float) -> void:
	progress_queue.value = amount

func _on_order_completed(amount : int) -> void:
	label_queue.text = "%s/%s" % [amount, Constants.MAX_PRODUCTION_QUEUE]
	progress_queue.value = 0.0

func update_production_projections() -> void:
	var base_cost = Player.MECH.get(Robots.Property.PRODUCTION_COST)
	var base_time = Player.MECH.get(Robots.Property.PRODUCTION_TIME)
	var weapon_cost := 0.0
	var weapon_time := 0.0
	var perk_cost := 0.0
	var perk_time := 0.0

	if Player.active_weapon != -1:
		weapon_cost = Upgrades.get_upgrade_property(Upgrades.Property.COST, Upgrades.Type.WEAPON, Player.active_weapon)
		weapon_time = Upgrades.get_upgrade_property(Upgrades.Property.PRODUCTION_TIME, Upgrades.Type.WEAPON, Player.active_weapon)

	if Player.active_perk != -1:
		perk_cost = Upgrades.get_upgrade_property(Upgrades.Property.COST, Upgrades.Type.PERK, Player.active_perk)
		perk_time = Upgrades.get_upgrade_property(Upgrades.Property.PRODUCTION_TIME, Upgrades.Type.PERK, Player.active_perk)

	label_cost.text = str((base_cost + weapon_cost + perk_cost) * production_quantity)
	label_time.text = str((base_time + weapon_time + perk_time) * production_quantity)

var amount_dragging := false
var amount_dragging_pos : Vector2

func _on_Panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		amount_dragging = event.pressed
		amount_dragging_pos = get_global_mouse_position()

	if amount_dragging:
		var drag_dir := amount_dragging_pos.direction_to(get_global_mouse_position()).round()
		var drag_dist := amount_dragging_pos.distance_to(get_global_mouse_position())

		if drag_dist < 10:
			return

		if drag_dir.x < 0 || drag_dir.y > 0:
			label_quantity.text = str(label_quantity.text.to_int() - 1)
		elif drag_dir.x > 0 || drag_dir.y < 0:
			label_quantity.text = str(label_quantity.text.to_int() + 1)

		amount_dragging_pos = get_global_mouse_position()
