class_name Wires
extends Item
func _init() -> void:
	spr_index = 1
	sell_value = ResourceManager.scrap_sells[1]
	value = Value.Scraps
	item_name = "Wires"
	item_desc = "Slightly Chewed"
