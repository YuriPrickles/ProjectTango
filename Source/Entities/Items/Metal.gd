class_name Metal
extends Item
func _init() -> void:
	spr_index = 0
	sell_value = ResourceManager.scrap_sells[0]
	value = Value.Scraps
	item_name = "Metal"
	item_desc = "Sturdy material for building things."
