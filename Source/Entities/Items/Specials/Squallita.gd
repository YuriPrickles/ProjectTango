class_name Squallita
extends Item

func _init(id:int) -> void:
	super._init(id)
	weapon_type = WeaponType.Thrown
	spr_index = 4
	value = Value.Special
	item_name = "Princess Squallita"
	item_desc = "[T] to throw for area damage\n[Enter] to skip targeting"
	custom_pickup = SquallitaPickup
	sell_value = -1
