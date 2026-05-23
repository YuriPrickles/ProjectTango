class_name Item
extends Resource
static var artifacts_floor1 = [
	ScreamingVoidAxe,
	SporeMother,
	PrairieKingGun,
	MultiGrainWaffle,
	TomeOfTheHills
	]
enum Value{
	Junk = 5,
	Scraps = 6,
	Normal = 7,
	Artifact = 9,
	Special = 12
}
##Determines the default action for the item's on_use().[br]
##Regular will do nothing.[br]
##Edible will consume the item by default[br]
##Thrown will enter Throw Mode to throw the item. (The item is actually thrown)
enum WeaponType {
	Unusable,
	Regular,
	Edible,
	Thrown,
	Consumable
}
var weapon_type:WeaponType = WeaponType.Unusable
var has_picked_up_before = false
var spr_index:int = 16
var value:Value = Value.Normal
var item_name:String = "Nothing"
var item_desc = "null"

var sell_value:int = 1
var custom_pickup:Script = null
var passive_effect:Effect = null

var item_damage = 0
var item_usedelay:float = 0
var item_timer:float = 0

func get_proper_item_name(): return Main.main_lang.get_dialog(item_name)
func _init() -> void:
	var name_key:String = str(get_script().get_global_name()).to_upper().replace(" ","_")
	var desc_key:String = str(get_script().get_global_name()).to_upper().replace(" ","_")
	item_name = ("ITEM_%s" % name_key)
	item_desc = ("ITEM_DESC_%s" % desc_key)

##Called when an item is picked up as a Pickup.
func on_pickup():
	if not has_picked_up_before and value == Value.Artifact:
		Main.main.add_peril(15)
	Main.main.resources.try_place_inventory(self.get_script())
	if Main.main.resources.get_selected_item():
		print(Main.main.resources.get_selected_item().item_name + " " + item_name)
		if Main.main.resources.get_selected_item().item_name == item_name:
			on_switch_to()
		else:
			on_switch_away()

func _process(delta: float) -> void:
	if weapon_type == WeaponType.Unusable:
		return
	if item_timer > 0 and item_usedelay != 0:
		item_timer = clamp(item_timer - delta,0,item_usedelay)

func on_use() -> bool:
	var plr:Player = Main.main.get_player()
	if not can_use(): return false
	if weapon_type == WeaponType.Edible:
		on_eat(plr)
		Main.main.resources.remove_inv_item()
		return true
	if weapon_type == WeaponType.Consumable:
		on_consume(plr)
		Main.main.resources.remove_inv_item()
		return true
	var useevent = ItemUseEvent.new(self)
	item_timer = item_usedelay * useevent.usedelay_mod
	if weapon_type == WeaponType.Thrown:
		plr.throw()
	return true

func can_use() -> bool:
	if item_timer > 0 or weapon_type == WeaponType.Unusable or Main.main.get_level().id == LevelID.Above:
		return false
	return true

func forced_passive_effect():
	pass

func on_eat(plr:Player):
	@warning_ignore("unused_variable")
	var eatevent = EatEvent.new(plr,self)

func on_consume(plr:Player):
	pass

func on_throw():
	remove_passive()

func on_switch_to():
	print("switch to %s" % self.item_name)
	remove_passive()

func on_switch_away():
	print("switch away from %s" % self.item_name)
	do_passive()

func remove_passive():
	if not passive_effect: return
	print("%s has Passive Effect off: %s" % [self.item_name, passive_effect.effect_name])
	var bus = Main.main.get_level().event_bus
	bus.unregister_effect(passive_effect)

func do_passive():
	if not passive_effect: return
	print("%s has Passive Effect on: %s" % [self.item_name, passive_effect.effect_name])
	var bus = Main.main.get_level().event_bus
	bus.register_effect(passive_effect)

func get_sell_string():
	if sell_value <= -1:
		return "unsellable"
	if sell_value == 0:
		return "no value"
	return "%s eeples" % sell_value
