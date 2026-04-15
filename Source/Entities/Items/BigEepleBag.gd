class_name BigEepleBag
extends Item

func _init() -> void:
	spr_index = 9
	weapon_type = WeaponType.Consumable
	value = Value.Normal
	item_name = "Big Bag of Eeples"
	item_desc = "add_money(randi_range(10,15))"
	sell_value = 3

func on_consume(plr:Player):
	Main.main.resources.add_money(randi_range(10,15))
	
