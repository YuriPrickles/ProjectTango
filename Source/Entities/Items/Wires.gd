class_name Wires
extends Item
func _init() -> void:
	spr_index = 1
	sell_value = Main.main.resources.scrap_sells[1]
	value = Value.Scraps
	super()

func on_switch_to():
	super()
	sell_value = Main.main.resources.scrap_sells[1]
