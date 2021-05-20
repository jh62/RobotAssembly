extends Node

# "res://scenes/Base/Base.gd"
signal on_queue_step(amount)
signal on_order_completed(production_queue_size)

# "res://scenes/CentralPanel/CentralPanel.tscn"
signal on_build_requested(amount, weapon_id, perk_id, time)
signal on_build_begin(amount, production_time)
signal on_build_cancel()
signal on_quantity_changed(amount)

# "res://scenes/SelectionPanel/SelectionPanel.tscn"
signal on_upgrade_changed(upgrade_type, upgrade_id)

# "res://scenes/PreviewPanel/PreviewPanel.gd"
signal on_upgrade_installed(upgrade_type, upgrade_id)
signal on_upgrade_removed(upgrade_type, upgrade_id)

# "res://scenes/PowerModule/PowerModule.gd"
signal on_PowerModule_collected(amount)

#
signal toggle_view_upgrades()
