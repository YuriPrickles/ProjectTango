class_name TomeOfTheHills
extends Item

func _init() -> void:
	spr_index = 11
	weapon_type = WeaponType.Regular
	value = Value.Artifact
	item_name = "Tome of the Hiils"
	item_desc = "(Passive): if event is UpdateEvent:\nfor proj in level.get_projectiles():\n    if timer > 0.3:\n        proj.damage += 1\n        timer = 0"
	sell_value = 25
	item_damage = 7
	item_usedelay = 0.5
	passive_effect = Passive_TomeOfTheHills.new()

func _process(delta: float) -> void:
	super._process(delta)

func on_use() -> bool:
	if not super.on_use(): return false
	var plr:Player = Main.main.get_player()
	HomingBolt.new(
		null,
		plr.Center - Vector2(2,2),
		plr.facing * 0.3,
		plr.get_damage(item_damage)
		)
	return true

class Passive_TomeOfTheHills:
	extends Effect
	var timer:float = 0
	func _init() -> void:
		effect_name = "Concentration"
	func process_event(event:Event):
		if event is UpdateEvent:
			timer += event.delta
			if timer > 0.3:
				timer = 0
				var lvl = Main.main.get_level()
				for proj:Projectile in lvl.get_projectiles():
					proj.damage += 1
		pass
