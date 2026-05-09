class_name BigEepleBag
extends Item

func _init() -> void:
	spr_index = 9
	weapon_type = WeaponType.Consumable
	value = Value.Normal
	sell_value = 3
	super()

func on_consume(plr:Player):
	Main.main.resources.add_money(randi_range(10,15))
	
