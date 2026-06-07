class_name SporeMother
extends Item

func _init() -> void:
	spr_index = 7
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	sell_value = 25
	item_damage = 1
	item_usedelay = 0.6
	passive_effect = Passive_SporeMother.new()
	super()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	for i in range(7):
		Spore.new(
			null,
			plr.position + plr.facing * 8,
			(plr.facing * (5 + randf_range(-2,2))).rotated(deg_to_rad(randf_range(-30,30))),
			plr.get_damage(item_damage)
			)
	return true

class Passive_SporeMother:
	extends Effect
	
	func _init() -> void:
		effect_name = "Spore Burst"
		icon_atlas = Main.ItemAtlas
		icon_index = 7
	
	func process_event(event:Event):
		if event is DamageEvent and event.target is Player:
			var plr = (event as DamageEvent).target
			for i in range(30):
				Spore.new(
					null,
					plr.position - plr.size/2,
					(plr.facing * (7 + randf_range(-3,3))).rotated(deg_to_rad(randf_range(-360,360))),
					plr.get_damage(event.damage * 0.8)
					).lifetime = 15
