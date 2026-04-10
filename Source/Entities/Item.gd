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
##Edible will consume the item by default[br]
##Thrown will enter Throw Mode to throw the item. (The item is actually thrown)
enum WeaponType {
	Unusable,
	Regular,
	Edible,
	Thrown
}
var weapon_type:WeaponType = WeaponType.Unusable
var has_picked_up_before = false
var spr_index:int = 16
var value:Value = Value.Normal
var item_name:String = "Nothing"
var item_desc:String = "null"

var sell_value:int = 1
var custom_pickup:Script = null
var passive_effect:Effect = null

var item_damage = 0
var item_usedelay = 0
var item_timer = 0

func get_desc()->String:
	var new_desc = item_desc
	var regex = RegEx.new()
	regex.compile("(?<red_ones>(!=|==|<|>|<=|>=null|true|false|and|not|or|is)(?!\\w))|(?<control>(for|if|else|elif)(?!\\w))|(?<numerical>(?<![\"\'])([0-9]+([.][0-9]+)?)(?![\"\']))|(?<func_name>[A-Za-z]+(?=(\\(.*\\))+))|(?<string>(\"|\').+\\7)")
	var groups = {
		"numerical":"B",
		"func_name":"D",
		"string":"A",
		"red_ones":"8",
		"control":"E",
		}
	var search = regex.search_all(new_desc)
	var saved_length = 0
	for result:RegExMatch in search:
		for group in groups.keys():
			var res_str = result.get_string(group)
			var num_color_string = "¬%s%s¬¬"%[groups.get(group),res_str]
			var start = result.get_start(group)
			var end = result.get_end(group)
			if start != -1:
				new_desc = new_desc.erase(start + saved_length, end - start)
				new_desc = new_desc.insert(start + saved_length, num_color_string)
				saved_length += num_color_string.length() - res_str.length()
	return new_desc

##Called when an item is picked up as a Pickup.
func on_pickup():
	if self == Main.main.resources.get_selected_item():
		on_switch_to()
	else:
		do_passive()
	forced_passive_effect()
	if not has_picked_up_before and value == Value.Artifact:
		Main.main.add_peril(5)
	Main.main.resources.try_place_inventory(self.get_script())
	pass

func _process(delta: float) -> void:
	if weapon_type == WeaponType.Unusable:
		return
	if item_timer > 0 and item_usedelay != 0:
		item_timer = clamp(item_timer - delta,0,item_usedelay)

func on_use() -> bool:
	var plr:Player = Main.main.get_player()
	if not can_use(): return false
	if weapon_type == WeaponType.Edible:
		on_consume(plr)
		Main.main.resources.remove_inv_item()
		return true
	item_timer = item_usedelay
	if weapon_type == WeaponType.Thrown:
		plr.throw()
	return true

func can_use() -> bool:
	if item_timer > 0 or weapon_type == WeaponType.Unusable:
		return false
	return true

func forced_passive_effect():
	pass

func on_consume(plr:Player):
	var conevent = ConsumeEvent.new(plr,self)

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
