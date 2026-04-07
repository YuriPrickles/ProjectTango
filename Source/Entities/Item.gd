class_name Item
extends Node
enum Value{
	Junk = 5,
	Scraps = 6,
	Normal = 7,
	Artifact = 9,
	Special = 12
}
##Determines the default action for the item's on_use().[br]
##Regular will do nothing.[br]
##Thrown will enter Throw Mode to throw the item. (The item is actually thrown)
enum WeaponType {
	Regular,
	Thrown
}
var weapon_type:WeaponType = WeaponType.Regular
var has_picked_up_before = false
var item_id = -1
var spr_index:int = 16
var value:Value = Value.Normal
var item_name:String = "Nothing"
var item_desc:String = "This shouldn't exist."
var sell_value:int = 1
var custom_pickup:Script = null

func _init(id:int) -> void:
	item_id = id
	spr_index = id

static func new_item(id:int) -> Item:
	match id:
		ItemID.Metal: return Metal.new(id)
		ItemID.Wires: return Wires.new(id)
		ItemID.Battery: return Battery.new(id)
		ItemID.GoldenToad: return GoldenToad.new(id)
		ItemID.Squallita: return Squallita.new(id)
	return null

##Called when an item is picked up as a Pickup.
func on_pickup():
	if not has_picked_up_before and value == Value.Artifact:
		Main.main.add_peril(5)
	Main.main.resources.try_place_inventory(self)
	pass

func on_use():
	if weapon_type == WeaponType.Thrown:
		var plr:Player = Main.main.get_player()
		plr.throw()
	pass

func passive_effect():
	pass

func forced_passive_effect():
	pass
