class_name RedBerries
extends Item

func _init() -> void:
	spr_index = 3
	value = Value.Normal
	item_name = "Red Berries"
	item_desc = "heal 2"
	sell_value = 3

func on_use() -> bool:
	var plr := Main.main.get_player()
	plr.heal(2)
	Main.main.resources.remove_inv_item()
	return true
