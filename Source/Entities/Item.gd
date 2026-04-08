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
	Unusable,
	Regular,
	Thrown
}
var weapon_type:WeaponType = WeaponType.Unusable
var has_picked_up_before = false
var item_id = -1
var spr_index:int = 16
var value:Value = Value.Normal
var item_name:String = "Nothing"
var item_desc:String = "This shouldn't exist."
var sell_value:int = 1
var custom_pickup:Script = null

var item_damage = 0
var item_usedelay = 0
var item_timer = 0

func _init(id:int) -> void:
	item_id = id
	spr_index = id

static func new_item(id:int) -> Item:
	match id:
		ItemID.Metal: return Metal.new(id)
		ItemID.Wires: return Wires.new(id)
		ItemID.Battery: return Battery.new(id)
		ItemID.RedBerries: return RedBerries.new(id)
		ItemID.Squallita: return Squallita.new(id)
		ItemID.ScreamingVoidAxe: return ScreamingVoidAxe.new(id)
	return null

static func new_new_item(item:GDScript) -> Item:
	return item.new()

##Called when an item is picked up as a Pickup.
func on_pickup():
	if not has_picked_up_before and value == Value.Artifact:
		Main.main.add_peril(5)
	Main.main.resources.try_place_inventory(self)
	pass

func _process(delta: float) -> void:
	forced_passive_effect()
	if Main.main.resources.get_selected_item() != self:
		passive_effect()
	if weapon_type == WeaponType.Unusable:
		return
	if item_timer > 0 and item_usedelay != 0:
		print("%s reload: %s" % [item_name,item_timer])
		item_timer = clamp(item_timer - delta,0,item_usedelay)

func on_use() -> bool:
	if not can_use(): return false
	item_timer = item_usedelay
	if weapon_type == WeaponType.Thrown:
		var plr:Player = Main.main.get_player()
		plr.throw()
	return true

func can_use() -> bool:
	if item_timer > 0 or weapon_type == WeaponType.Unusable:
		return false
	return true

func passive_effect():
	pass

func forced_passive_effect():
	pass

func effect_on_passive(effect_id:int):
	var plr:Player = Main.main.get_player()
	plr

func get_sell_string():
	if sell_value <= -1:
		return "unsellable"
	if sell_value == 0:
		return "no value"
	return "%s eeples" % sell_value
