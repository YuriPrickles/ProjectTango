class_name ResourceManager
extends Resource

static var scrap_sells=[0,0,0]
var money:int = 0
var peril:int = 0
var peril_block:int = 0

var inventory:Array[Item]
var inv_selected:
	get: return inv_selected
	set(value): inv_selected = (value % 15)

func initialize_inventory():
	for i in range(3):
		scrap_sells[i] = RandomNumberGenerator.new().randi_range(2,7)
	money = 999
	inv_selected = 0
	inventory.resize(15)
	inventory.fill(null)
	inventory[0] = Item.new_item(ItemID.Squallita)
	inventory[1] = Item.new_item(ItemID.ScreamingVoidAxe)
	inventory[2] = Item.new_item(ItemID.RedBerries)


func add_money(value):
	money += value

func spend_money(value):
	money -= value
func get_selected_item() -> Item:
	return inventory[inv_selected]
	
func remove_inv_item(index:int=inv_selected):
	inventory[index] = null
func is_inventory_full():
	for i in inventory:
		if i == null:
			return false
	return true

func try_place_inventory(item:Item):
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = Item.new_item(item.item_id)
			return true;
	return false
