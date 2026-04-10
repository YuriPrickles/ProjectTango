class_name ResourceManager
extends Resource

static var scrap_sells=[0,0,0]
var money:int = 0
var peril:int = 0
var peril_block:int = 0

var inventory:Array[Item]
var inv_selected:
	get:
		if not inv_selected: return 0
		return inv_selected
	set(value):
		if inventory[inv_selected]: inventory[inv_selected].on_switch_away()
		inv_selected = (value % 15)
		for thing in inventory:
			if not thing: continue
			if thing == inventory[inv_selected]:
				inventory[inv_selected].on_switch_to()
			else:
				thing.do_passive()
		if Main.main.get_level():
			print(Main.main.get_level().event_bus.get_effects())

func initialize_inventory():
	for i in range(3):
		scrap_sells[i] = RandomNumberGenerator.new().randi_range(2,7)
	money = 999
	inventory.resize(15)
	inventory.fill(null)
	inv_selected = 0
	inventory[0] = Squallita.new()
	inventory[1] = ScreamingVoidAxe.new()
	inventory[2] = MultiGrainWaffle.new()
	inventory[3] = RedBerries.new()


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

func try_place_inventory(item:GDScript):
	for i in inventory.size():
		if inventory[i] == null:
			var item_object:Item = item.new()
			inventory[i] = item_object
			if not i == inv_selected:
				item_object.do_passive()
			return true;
	return false
