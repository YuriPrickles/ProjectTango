class_name RedBerries
extends Item

func _init() -> void:
	spr_index = 3
	weapon_type = WeaponType.Edible
	value = Value.Normal
	item_name = "Red Berries"
	item_desc = "plr.heal(15)"
	sell_value = 3

func on_use() -> bool:
	var plr := Main.main.get_player()
	plr.heal(15)
	super.on_use()
	return true
