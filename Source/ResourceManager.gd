class_name ResourceManager
extends Resource

var scrap_sells=[0,0,0]
@export var money:int = 0
var peril:int = 0
var peril_block:int = 0

var disc_shop:Array[Disc]
@export var inventory:Array[Item]
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
		if Main.main.get_level() and not Main.main.get_level().event_bus.get_effects().is_empty():
			print(Main.main.get_level().event_bus.get_effects())

const MAX_DISCS_IN_SHOP = 14
func new_run_refresh():
	peril = 0
	peril_block = 0
	for i in range(3):
		scrap_sells[i] = RandomNumberGenerator.new().randi_range(2,7)
	disc_shop.clear()
	var rarity_weights:Dictionary[int,Disc.Rarity] ={
		7: Disc.Rarity.Common,
		5: Disc.Rarity.Uncommon,
		2: Disc.Rarity.Rare,
	}
	for weight:int in rarity_weights.keys():
		for i in range(weight):
			var rarity = rarity_weights.get(weight)
			if rarity_weights.get(weight) == Disc.Rarity.Rare and randi() % 100 < 3:
				rarity = Disc.Rarity.Scrumptious
			var disc = Main.disc_manager.get_of_rarity(rarity)
			if not disc:
				Main.disc_manager.get_of_rarity(Disc.Rarity.Common)
			disc_shop.append(disc)

func initialize_inventory():
	money = 0
	inventory.resize(15)
	inventory.fill(null)
	inv_selected = 0
	money = 0


func add_money(value):
	money += value
	if Main.main.get_level().id != LevelID.Above:
		Main.main.run_gui.gui_drawificator.money_opacity = 1

func spend_money(value):
	money -= value
func get_selected_item() -> Item:
	if inventory.is_empty():
		return null
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
			else:
				item_object.remove_passive()
			return true;
	return false
