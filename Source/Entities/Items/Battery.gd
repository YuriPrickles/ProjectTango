class_name Battery
extends Item
func _init() -> void:
	spr_index = 2
	sell_value = Main.main.resources.scrap_sells[2]
	value = Value.Scraps
	super()

func on_switch_to():
	super()
	sell_value = Main.main.resources.scrap_sells[2]
