class_name Metal
extends Item
func _init() -> void:
	spr_index = 0
	sell_value = Main.main.resources.scrap_sells[0]
	value = Value.Scraps
	item_desc = "Sturdy material for building things."
	super()

func on_switch_to():
	super()
	sell_value = Main.main.resources.scrap_sells[0]
