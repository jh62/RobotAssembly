extends Node

# "res://scenes/CentralPanel/CentralPanel.tscn"
signal on_build_begin()
signal on_build_cancel()
signal on_quantity_changed(amount)

# "res://scenes/SelectionPanel/SelectionPanel.tscn"
signal on_upgrade_changed(upgrade_type, upgrade_id)
