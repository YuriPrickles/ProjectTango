class_name ResourceManager
extends Resource

enum Scraps {
	METAL,
	WIRES,
	BATTERY,
	NONE
}

var instability:int = 0
var unreality:int = 0

var inventory:Array[Item]
var inv_selected:
	get: return inv_selected
	set(value): inv_selected = (value % 15)

func initialize_inventory():
	inv_selected = 0
	inventory.resize(15)
	inventory.fill(null)

func is_inventory_full():
	for i in inventory:
		if i == null:
			return false
	return true

func try_place_inventory(item:Item):
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item
			print("inv empty")
			return true;
	print("inv full")
	return false
