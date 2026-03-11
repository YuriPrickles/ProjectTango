class_name Item
extends Node

var item_id = -1
var spr_index:int = 16
var item_name:String = "Nothing"
var item_desc:String = "This shouldn't exist."

func _init(id:int) -> void:
	item_id = id
	spr_index = id

static func new_item(id:int) -> Item:
	
	match id:
		ItemID.Metal: return Metal.new(id)
		ItemID.Wires: return Wires.new(id)
		ItemID.Battery: return Battery.new(id)
	return null

##Called when an item is picked up as a Pickup.
func on_pickup():
	Main.main.resources.try_place_inventory(self)
	pass
