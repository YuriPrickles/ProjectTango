class_name Item
extends Node

static var item_id = -1
var spr_index:int = 16
var item_name:String = "Nothing"
var item_desc:String = "This shouldn't exist."


static func new_item(id:int) -> Item:
	item_id = id
	match id:
		ItemID.Metal: return Metal.new()
		ItemID.Wires: return Wires.new()
		ItemID.Battery: return Battery.new()
	return null

##Called when an item is picked up as a Pickup.
func on_pickup():
	Main.main.resources.try_place_inventory(self)
	pass
