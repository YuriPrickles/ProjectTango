class_name MultiGrainWaffle
extends Item

func _init() -> void:
	spr_index = 6
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	sell_value = 25
	item_damage = 3
	item_usedelay = 0.5
	passive_effect = Passive_MultiGrainWaffle.new()
	super()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	Waffle.new(
		null,
		plr.position,
		plr.facing * 2,
		plr.get_damage(item_damage)
		)
	return true
class Passive_MultiGrainWaffle:
	extends Effect

	func _init() -> void:
		effect_name = "Yummy Blessing"
		icon_atlas = Main.ItemAtlas
		icon_index = 6

	func process_event(event:Event):
		if event is EatEvent:
			if event.player and event.item:
				var plr : Player = event.player
				plr.heal(10)
				pass
